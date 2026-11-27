-- Keeps installed plugins at the commits in the repo's lazy-lock.json.
--
-- The repo's lazy-lock.json is the source of plugin versions on every
-- platform. lazy.nvim only ever works on a private copy in the state
-- directory, because after installing anything it rewrites its lockfile from
-- whatever commits are on disk. Writing the repo's file directly would let
-- leftover plugins (from another config, or not yet restored after a git
-- pull) overwrite the pins.
--
-- - On startup, if the repo's pins differ from the ones last restored (first
--   run, git pull, new flake build), installed plugins are moved to them with
--   `:Lazy restore`.
-- - After `:Lazy update` or `:Lazy sync`, the new pins are copied back to the
--   repo (when it's writable, so not the Nix store) to be committed.

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

--- Fingerprint of the repo lockfile the installed plugins were last restored to.
M.stamp_path = vim.fn.stdpath("state") .. "/lazy-lock.sha256"

--- lazy.nvim's own copy of the lockfile.
M.lazy_lock = vim.fn.stdpath("state") .. "/lazy-lock.json"

---@param root string Directory containing lazy-lock.json
function M.prepare(root)
  local repo_lock = root .. "/lazy-lock.json"
  M.repo_lock = repo_lock

  --- Reset lazy.nvim's copy to the repo's pins
  local function load_repo_pins()
    local content = read(repo_lock)
    if content and read(M.lazy_lock) ~= content then
      write(M.lazy_lock, content)
    end
    -- lazy.nvim caches the lockfile once read
    local ok, lock = pcall(require, "lazy.manage.lock")
    if ok then
      lock._loaded = false
    end
  end
  load_repo_pins()

  -- Checked now, before lazy.nvim installs anything
  local hash = fingerprint(repo_lock)
  local changed = hash ~= nil and read(M.stamp_path) ~= hash

  local group = vim.api.nvim_create_augroup("config.lockfile", {})
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "LazyRestore",
    desc = "Record that the installed plugins match the repo's pins",
    callback = function()
      local new = fingerprint(repo_lock)
      if new then
        write(M.stamp_path, new)
      end
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = { "LazyUpdate", "LazySync" },
    desc = "Save updated pins to the repo's lazy-lock.json",
    callback = function()
      if vim.fn.filewritable(repo_lock) ~= 1 then
        -- Read-only (Nix store): keep the updates for this session only
        os.remove(M.stamp_path)
        vim.notify(
          "lazy-lock.json is read-only, so these updates are temporary: plugins go back to its pins on the next start",
          vim.log.levels.WARN
        )
        return
      end
      -- lazy.nvim saves its lockfile just after this event; do it now so the
      -- pins are copied even if Neovim exits straight away (`+Lazy! update`)
      require("lazy.manage.lock").update()
      local content = read(M.lazy_lock)
      if content then
        write(repo_lock, content)
        write(M.stamp_path, assert(fingerprint(repo_lock)))
      end
    end,
  })

  return {
    path = M.lazy_lock,
    restore_if_changed = function()
      if not changed then
        return
      end
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          vim.notify("lazy-lock.json changed, restoring plugins")
          -- Installing missing plugins at startup may have changed lazy.nvim's
          -- copy, so start again from the repo's pins
          load_repo_pins()
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
