-- Bootstraps and configures lazy.nvim.
local M = {}

--- The commit lazy-lock.json pins lazy.nvim itself to, if any.
---@param root string
---@return string?
local function locked_commit(root)
  local file = io.open(root .. "/lazy-lock.json", "r")
  if not file then
    return nil
  end
  local ok, lock = pcall(vim.json.decode, file:read("*a"))
  file:close()
  return ok and vim.tbl_get(lock, "lazy.nvim", "commit") or nil
end

--- Clone lazy.nvim on first start. It's checked out at its locked commit,
--- because lazy.nvim only checks out lockfile commits for plugins it
--- installs itself, and it never installs itself.
---@param root string
local function bootstrap(root)
  local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(path) then
    local function git(args)
      local out = vim.fn.system(vim.list_extend({ "git" }, args))
      if vim.v.shell_error ~= 0 then
        error("Failed to install lazy.nvim:\n" .. out)
      end
    end

    local commit = locked_commit(root)
    git({ "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", path })
    git({ "-C", path, "checkout", "--quiet", commit or "stable" })
  end
  vim.opt.rtp:prepend(path)
end

---@param opts { root: string, is_config_dir: boolean }
function M.setup(opts)
  bootstrap(opts.root)

  local platform = require("config.platform")
  local lockfile = require("config.lockfile").prepare(opts.root)

  require("lazy").setup({
    spec = { { import = "plugins" } },
    lockfile = lockfile.path,
    defaults = {
      -- Inside VSCode only plugins marked `vscode = true` load
      cond = function(plugin)
        return not platform.is_vscode or plugin.vscode == true
      end,
    },
    install = { colorscheme = { "catppuccin", "habamax" } },
    -- No plugin here needs luarocks, which is painful to get on Windows
    rocks = { enabled = false },
    change_detection = { notify = false },
    performance = {
      rtp = {
        -- lazy.nvim resets the runtimepath, so add this repo back when it
        -- isn't the standard config directory
        paths = opts.is_config_dir and {} or { opts.root, opts.root .. "/after" },
      },
    },
  })

  lockfile.restore_if_changed()
end

return M
