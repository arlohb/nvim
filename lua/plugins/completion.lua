---@type LazySpec
return {
  {
    "saghen/blink.cmp",
    -- Release tags have prebuilt binaries for the fuzzy matcher
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
      -- Runs nvim-cmp sources that have no blink.cmp equivalent
      { "saghen/blink.compat", version = "2.*", lazy = true, opts = {} },
      "kdheepak/cmp-latex-symbols",
    },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "none",
        ["<CR>"] = { "accept", "fallback" },
        ["K"] = { "select_prev", "fallback" },
        ["J"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "scroll_documentation_up", "fallback" },
        ["<C-j>"] = { "scroll_documentation_down", "fallback" },
      },

      sources = {
        default = { "lazydev", "lsp", "snippets", "latex_symbols" },
        providers = {
          -- Neovim API completion when editing Lua (lazydev is in lsp.lua)
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          latex_symbols = {
            name = "latex_symbols",
            module = "blink.compat.source",
            -- Insert the LaTeX command instead of the symbol
            opts = { strategy = 2 },
          },
        },
      },

      completion = {
        menu = { border = "rounded" },
        documentation = {
          auto_show = true,
          window = { border = "rounded" },
        },
      },

      -- Function signature popup while typing arguments
      signature = {
        enabled = true,
        window = { border = "rounded" },
      },

      -- Command line completion wasn't set up before; keep it off
      cmdline = { enabled = false },
    },
  },
}
