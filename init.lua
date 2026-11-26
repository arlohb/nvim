-- Entry point.
--
-- Works both as the normal config directory (~/.config/nvim, or
-- %LOCALAPPDATA%\nvim on Windows) and from anywhere via
-- `nvim -u /path/to/init.lua`, which is how the Nix wrapper runs it.

vim.loader.enable()

-- The directory containing this file. If it isn't the standard config
-- directory, it has to be added to the runtimepath by hand.
local root = vim.fs.dirname(vim.fs.normalize(debug.getinfo(1, "S").source:sub(2)))
local function realpath(path)
  return vim.uv.fs_realpath(path) or path
end
local is_config_dir = realpath(root) == realpath(vim.fn.stdpath("config"))
if not is_config_dir then
  vim.opt.rtp:prepend(root)
  vim.opt.rtp:append(root .. "/after")
end

require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.lazy").setup({ root = root, is_config_dir = is_config_dir })
