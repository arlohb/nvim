local platform = require("config.platform")

-- Installed on startup. Others install the first time a file of that type
-- is opened.
-- stylua: ignore
local parsers = {
  "bash", "c", "c_sharp", "clojure", "cpp", "css", "elixir", "go", "haskell",
  "html", "java", "javascript", "json", "kotlin", "lua", "markdown",
  "markdown_inline", "nix", "ocaml", "python", "query", "rust", "svelte",
  "toml", "tsx", "typescript", "vim", "vimdoc", "yaml", "zig",
}

--- Start treesitter highlighting and indentation for a buffer.
---@return boolean started false if there's no parser for the buffer
local function start(buf, lang)
  if not pcall(vim.treesitter.start, buf, lang) then
    return false
  end
  -- Keep regex highlighting alongside treesitter
  vim.bo[buf].syntax = "ON"
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  return true
end

---@type LazySpec
return {
  -- The main branch only installs parsers; highlighting is Neovim's own.
  -- Compiling parsers needs the tree-sitter CLI and a C compiler on PATH.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({})

      -- Without the CLI installs fail, so just use whatever is installed
      local can_install = platform.has("tree-sitter")
      if can_install then
        ts.install(parsers)
      end

      local available ---@type string[]?
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("config.treesitter", {}),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang or start(ev.buf, lang) or not can_install then
            return
          end

          available = available or ts.get_available()
          if vim.tbl_contains(available, lang) then
            ts.install(lang):await(function()
              if vim.api.nvim_buf_is_valid(ev.buf) then
                start(ev.buf, lang)
              end
            end)
          end
        end,
      })
    end,
  },

  -- Colour matching brackets
  {
    url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    name = "rainbow-delimiters.nvim",
    init = function()
      vim.g.rainbow_delimiters = {
        -- Highlight groups are defined in ui.lua.
        -- Red and green are left out because it looks better.
        highlight = { "RainbowOrange", "RainbowYellow", "RainbowBlue", "RainbowViolet" },
      }
    end,
  },
}
