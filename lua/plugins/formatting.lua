-- Filetypes with format on save turned on. Off by default; <leader>cF
-- toggles it for the current buffer's filetype, for the rest of the session.
local format_on_save = {} ---@type table<string, true>

local function toggle_format_on_save()
  local ft = vim.bo.filetype
  if ft == "" then
    vim.notify("This buffer has no filetype", vim.log.levels.WARN)
    return
  end
  format_on_save[ft] = not format_on_save[ft] or nil
  vim.notify(("Format on save %s for %s files"):format(format_on_save[ft] and "on" or "off", ft))
end

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
      { "<leader>cF", toggle_format_on_save, desc = "Toggle format on save (filetype)" },
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
      format_on_save = function(buf)
        if format_on_save[vim.bo[buf].filetype] then
          return { timeout_ms = 1000 }
        end
      end,
    },
  },
}
