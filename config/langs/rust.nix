{ pkgs, ... }:
{
  nixvim.plugins.rust-tools = {
    enable = true;
    serverPackage = null;
    extraOptions = {
      tools = {
        inlay_hints = {
          auto = false;
        };
      };
      server = {
        on_attach = { __raw = ''
          function(_, bufnr)
            vim.keymap.set("n", "K", require("rust-tools").hover_actions.hover_actions, { desc = "Hover" })

            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end
        ''; };
        settings = {
          rust-analyzer = {
            check = {
              command = "clippy";
            };
            # https://github.com/rust-lang/rust-analyzer/issues/7497#issuecomment-770243115
            cargo = {
              loadOutDirsFromCheck = true;
            };
            procMacro = {
              enable = true;
            };
          };
        };
      };
      dap = {
        # Haven't got working on nix yet
        # adapter = require("rust-tools.dap").get_codelldb_adapter(
        #     vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb",
        #     vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.so"
        # ),
      };
    };
  };
}
