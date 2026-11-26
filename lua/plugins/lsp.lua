-- Server-specific settings are in after/lsp/<server>.lua, which Neovim
-- merges on top of nvim-lspconfig's lsp/<server>.lua.

local platform = require("config.platform")

-- Binaries aren't installed by this config. On Nix they come from each
-- project's direnv shell; elsewhere from :Mason or the system package
-- manager. A server whose binary is missing just doesn't start.
local servers = {
  "rust_analyzer",
  "clangd",
  "clojure_lsp",
  "omnisharp",
  "elixirls",
  "gopls",
  "hls",
  "jdtls",
  "kotlin_language_server",
  "lua_ls",
  "ocamllsp",
  "pylsp",
  "zls",
  -- Web
  "ts_ls",
  "html",
  "svelte",
  "eslint",
  "tailwindcss",
  "cssls",
  "denols",
}

---@param ev vim.api.keyset.create_autocmd.callback_args
local function on_attach(ev)
  local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
  end
  map("K", function()
    vim.lsp.buf.hover({ border = "rounded" })
  end, "Hover")
  map("gd", vim.lsp.buf.definition, "Goto definition")
  map("gD", vim.lsp.buf.declaration, "Goto declaration")
  map("go", vim.lsp.buf.type_definition, "Goto type definition")
  map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("<leader>cr", vim.lsp.buf.rename, "Rename")

  -- Format on save
  if client.name == "svelte" then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("config.lsp.format." .. ev.buf, {}),
      buffer = ev.buf,
      callback = function()
        vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
      end,
    })
  end
end

---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      -- Loaded first so servers it installed are on PATH
      { "mason-org/mason-lspconfig.nvim", optional = true },
    },
    keys = {
      { "<leader>ol", "<cmd>checkhealth vim.lsp<cr>", desc = "Lsp Info" },
    },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
      vim.lsp.enable(servers)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("config.lsp", {}),
        callback = on_attach,
      })

      vim.diagnostic.config({
        virtual_text = false,
        update_in_insert = true,
        float = {
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
      })
    end,
  },

  -- Installs servers when Nix isn't providing them
  {
    "mason-org/mason-lspconfig.nvim",
    cond = not platform.is_nix and not platform.is_vscode,
    cmd = { "LspInstall", "LspUninstall" },
    dependencies = {
      { "mason-org/mason.nvim", cmd = "Mason", opts = {} },
    },
    opts = {
      ensure_installed = { "lua_ls" },
      -- Servers are enabled above, wherever they came from
      automatic_enable = false,
    },
  },

  -- Completion and types for the Neovim API when editing this config
  { "folke/lazydev.nvim", ft = "lua", opts = {} },
}
