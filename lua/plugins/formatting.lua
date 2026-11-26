---@type LazySpec
return {
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true })
        end,
        mode = { "n", "x" },
        desc = "Format",
      },
    },
    init = function()
      -- Use conform for gq too
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      -- Formatters aren't installed by this config. On Nix they come from each
      -- project's dev shell; elsewhere from the system package manager.
      -- Run :ConformInfo to see which are available.
      formatters_by_ft = {
        lua = { "stylua" },
        nix = { "nixfmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
      },
      -- Everything else (Rust, Go, C, Zig, Svelte, ...) is formatted by its
      -- language server, as are these when no formatter is installed
      default_format_opts = { lsp_format = "fallback" },
    },
  },
}
