-- `:checkhealth config`: checks the external tools this config uses.
local M = {}

local platform = require("config.platform")

---@param exes string[]
---@return string?
local function first_found(exes)
  for _, exe in ipairs(exes) do
    if platform.has(exe) then
      return exe
    end
  end
end

---@param name string
---@param exes string[]
---@param purpose string
---@param required boolean
local function check_tool(name, exes, purpose, required)
  local found = first_found(exes)
  if found then
    vim.health.ok(("%s (`%s`): %s"):format(name, found, purpose))
  elseif required then
    vim.health.error(("%s not found: %s"):format(name, purpose))
  else
    vim.health.warn(("%s not found: %s"):format(name, purpose))
  end
end

function M.check()
  vim.health.start("Platform")
  vim.health.info("Windows: " .. tostring(platform.is_windows))
  vim.health.info("Nix wrapper: " .. tostring(platform.is_nix))
  vim.health.info("VSCode: " .. tostring(platform.is_vscode))

  vim.health.start("Plugins")
  local in_sync = require("config.lockfile").in_sync()
  if in_sync then
    vim.health.ok("Installed plugins match lazy-lock.json")
  else
    vim.health.warn("Installed plugins may not match lazy-lock.json", "Run `:Lazy restore`")
  end

  vim.health.start("Tools")
  check_tool("git", { "git" }, "installs plugins", true)
  check_tool("ripgrep", { "rg" }, "telescope file and text search", true)
  check_tool("fd", { "fd", "fdfind" }, "telescope, wiki links in markdown", false)
  check_tool("tree-sitter CLI", { "tree-sitter" }, "compiles treesitter parsers", false)
  check_tool("C compiler", { "cc", "gcc", "clang", "cl", "zig" }, "compiles treesitter parsers", false)
  if platform.is_windows then
    check_tool("PowerShell", { "pwsh", "powershell" }, "terminal shell", false)
  else
    check_tool("direnv", { "direnv" }, "loads project environments (LSP servers)", false)
  end
  check_tool("yt-dlp", { "yt-dlp" }, "lecture-notes YouTube downloads", false)
  check_tool("ffmpeg", { "ffmpeg" }, "lecture-notes YouTube downloads", false)
  check_tool("tectonic", { "tectonic" }, "snacks LaTeX image rendering", false)
  check_tool("ghostscript", { "gs", "gswin64c" }, "snacks LaTeX image rendering", false)
end

return M
