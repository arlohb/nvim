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

--- Git for Windows' bash.exe. Found next to git rather than as `bash` on
--- PATH, which on Windows is often WSL's.
---@return string?
function M.git_bash()
  local candidates = {}
  local git = vim.fn.exepath("git")
  if git ~= "" then
    -- git.exe is in Git/cmd or Git/mingw64/bin; bash.exe is in Git/bin
    for dir in vim.fs.parents(vim.fs.normalize(git)) do
      table.insert(candidates, dir .. "/bin/bash.exe")
    end
  end
  table.insert(candidates, "C:/Program Files/Git/bin/bash.exe")
  table.insert(candidates, vim.fs.normalize("~/scoop/apps/git/current/bin/bash.exe"))

  for _, bash in ipairs(candidates) do
    if vim.uv.fs_stat(bash) then
      return bash
    end
  end
end

return M
