-- Bootstraps and configures lazy.nvim.
local M = {}

local function bootstrap()
  local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(path) then
    local out = vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=stable",
      "https://github.com/folke/lazy.nvim.git",
      path,
    })
    if vim.v.shell_error ~= 0 then
      error("Failed to clone lazy.nvim:\n" .. out)
    end
  end
  vim.opt.rtp:prepend(path)
end

---@param opts { root: string, is_config_dir: boolean }
function M.setup(opts)
  bootstrap()

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
