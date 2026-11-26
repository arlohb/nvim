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

--- Keymap spec selecting a treesitter text object
---@param lhs string
---@param query string
---@param desc string
local function select(lhs, query, desc)
  return {
    lhs,
    function()
      require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
    end,
    mode = { "x", "o" },
    desc = desc,
  }
end

--- Keymap spec moving to a treesitter text object
---@param lhs string
---@param method "goto_next_start"|"goto_next_end"|"goto_previous_start"|"goto_previous_end"
---@param query string
---@param desc string
local function move(lhs, method, query, desc)
  return {
    lhs,
    function()
      require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
    end,
    mode = { "n", "x", "o" },
    desc = desc,
  }
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

  -- Text objects and motions for functions, classes and arguments.
  -- The motions are Vim's own ]m ]] etc., made to work in every language.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      select("af", "@function.outer", "a function"),
      select("if", "@function.inner", "inner function"),
      select("ac", "@class.outer", "a class"),
      select("ic", "@class.inner", "inner class"),
      select("aa", "@parameter.outer", "an argument"),
      select("ia", "@parameter.inner", "inner argument"),
      move("]m", "goto_next_start", "@function.outer", "Next function start"),
      move("[m", "goto_previous_start", "@function.outer", "Previous function start"),
      move("]M", "goto_next_end", "@function.outer", "Next function end"),
      move("[M", "goto_previous_end", "@function.outer", "Previous function end"),
      move("]]", "goto_next_start", "@class.outer", "Next class start"),
      move("[[", "goto_previous_start", "@class.outer", "Previous class start"),
      move("][", "goto_next_end", "@class.outer", "Next class end"),
      move("[]", "goto_previous_end", "@class.outer", "Previous class end"),
    },
    opts = {
      -- Jump forward to the next text object if the cursor isn't in one
      select = { lookahead = true },
      -- Add moves to the jumplist, so <C-o> goes back
      move = { set_jumps = true },
    },
  },

  -- Keep the enclosing function/class header pinned at the top of the window
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader>oc",
        function()
          local context = require("treesitter-context")
          context.toggle()
          vim.notify("Context " .. (context.enabled() and "on" or "off"))
        end,
        desc = "Toggle Context",
      },
      {
        "[x",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "Go to context",
      },
    },
    opts = {
      -- Don't let the pinned lines take over the window
      max_lines = 5,
      multiline_threshold = 1,
    },
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
