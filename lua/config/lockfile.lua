-- Keeps installed plugins at the commits in the repo's lazy-lock.json.
--
-- lazy-lock.json is the single source of plugin versions on every platform.
-- lazy.nvim installs missing plugins at the locked commits, but two cases
-- need help:
--
-- 1. When the config is read-only (the Nix store), lazy.nvim can't write
--    its lockfile, so it gets a writable copy in the state directory.
-- 2. When the repo's lockfile changes (git pull, or a new flake build),
--    already installed plugins are moved to the new commits with
--    `:Lazy restore`.

local M = {}

---@param path string
---@return string?
local function read(path)
  local file = io.open(path, "rb")
  if not file then
    return nil
  end
  local content = file:read("*a")
  file:close()
  return content
end

---@param path string
---@param content string
local function write(path, content)
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  local file = assert(io.open(path, "wb"))
  file:write(content)
  file:close()
end

--- Fingerprint of the plugin commits in a lockfile. Ignores formatting,
--- since lazy.nvim rewrites the file in its own layout.
---@param path string
---@return string?
local function fingerprint(path)
  local content = read(path)
  local ok, lock = pcall(vim.json.decode, content or "")
  if not ok or type(lock) ~= "table" then
    return nil
  end

  local names = vim.tbl_keys(lock)
  table.sort(names)
  local lines = {}
  for _, name in ipairs(names) do
    table.insert(lines, name .. " " .. tostring(lock[name].commit))
  end
  return vim.fn.sha256(table.concat(lines, "\n"))
end

--- Fingerprint of the lockfile the installed plugins were last synced to.
M.stamp_path = vim.fn.stdpath("state") .. "/lazy-lock.sha256"

---@param root string Directory containing lazy-lock.json
function M.prepare(root)
  local repo_lock = root .. "/lazy-lock.json"
  M.repo_lock = repo_lock

  local path = repo_lock
  if vim.fn.filewritable(root) ~= 2 then
    path = vim.fn.stdpath("state") .. "/lazy-lock.json"
    local content = read(repo_lock)
    if content and read(path) ~= content then
      write(path, content)
    end
  end

  -- Checked now, before lazy.nvim installs anything and updates the stamp
  local hash = fingerprint(repo_lock)
  local changed = hash ~= nil and read(M.stamp_path) ~= hash

  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("config.lockfile", {}),
    pattern = { "LazyInstall", "LazyRestore", "LazySync", "LazyUpdate" },
    desc = "Record which lockfile the installed plugins match",
    callback = function()
      -- lazy.nvim writes the lockfile after firing these events
      vim.schedule(function()
        local new = fingerprint(repo_lock)
        if new then
          write(M.stamp_path, new)
        end
      end)
    end,
  })

  return {
    path = path,
    restore_if_changed = function()
      if not changed then
        return
      end
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          vim.notify("lazy-lock.json changed, restoring plugins")
          -- The LazyRestore autocmd above records the new fingerprint, even
          -- if some plugins fail (e.g. offline); errors show in :Lazy
          require("lazy").restore({ show = false })
        end,
      })
    end,
  }
end

--- Whether the installed plugins were last synced to the repo's lockfile.
---@return boolean?
function M.in_sync()
  local hash = M.repo_lock and fingerprint(M.repo_lock)
  if not hash then
    return nil
  end
  return read(M.stamp_path) == hash
end

return M
