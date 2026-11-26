--- Facts about where Neovim is running, used to gate platform-specific config.
local M = {}

M.is_windows = vim.fn.has("win32") == 1

--- Set by the wrapper in flake.nix. Tools then come from Nix, so Mason is
--- not used.
M.is_nix = vim.env.ARLO_NVIM_NIX == "1"

--- Set by the vscode-neovim extension.
M.is_vscode = vim.g.vscode ~= nil

--- Whether an executable is on PATH.
---@param exe string
---@return boolean
function M.has(exe)
  return vim.fn.executable(exe) == 1
end

return M
