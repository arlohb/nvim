{ pkgs, lib, utils, ... }@inputs:
{
  # Provides correct tabbing and syntax highlighting
  nixvim.plugins.treesitter = {
    enable = true;
    settings.indent.enable = true;
    settings.highlight = {
      enable = true;
      additional_vim_regex_highlighting = true;
    };

    # TODO: Add custom treesitter extension to add lua highlighting to nix
    # Can use nixvimInjections to model on:
    #   docs: https://nix-community.github.io/nixvim/plugins/treesitter/index.html?highlight=treesitter#pluginstreesitternixviminjections
    #   src: https://github.com/nix-community/nixvim/blob/7c4fe30f814595bc617d6b1b682ab9cbfe535d33/plugins/languages/treesitter/treesitter.nix#L179
  };

  nixvim.plugins.lsp = {
    enable = true;

    postConfig = ''
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = "rounded",
        }
      )

      require("lspconfig.ui.windows").default_options = {
        border = "rounded",
      }

      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = true,
        underline = true,
        severity_sort = false,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
    '';

    capabilities = "capabilities.textDocument.completion.completionItem.snippetSupport = true";

    servers = let
      paths = utils.file_paths_in_dir ./lsps;
      modules = map
        (path: (import path) inputs)
        paths;
      mergedModule = utils.mergeAttrSets modules;
    in lib.attrsets.mapAttrs
      (name: value: value // { package = null; })
      mergedModule;
  };

  # cmp.settings.sources doesn't install this like it should
  vim-vsnip = "";

  # Auto complete
  nixvim.plugins.cmp = {
    enable = true;

    # Sources
    autoEnableSources = true;
    settings.sources = [
      { name = "nvim_lsp"; }
      { name = "nvim_lua"; }
      { name = "path"; }
      { name = "vsnip"; }
    ];

    # Snippets
    settings.snippet.expand = ''
      function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end
    '';

    # Make windows pretty
    settings.window = let
      # Got these values from cmp.config.window.bordered()
      window = {
        border = "rounded";
        col_offset = 0;
        scrollbar = true;
        scrolloff = 0;
        side_padding = 1;
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
        zindex = 1001;
      };
    in {
      completion = window;
      documentation = window;
    };

    # Key bindings
    settings.mapping = {
      "<cr>" = ''cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      })'';
      "K" = "cmp.mapping.select_prev_item()";
      "J" = "cmp.mapping.select_next_item()";
      "<Up>" = "cmp.mapping.select_prev_item()";
      "<Down>" = "cmp.mapping.select_next_item()";
      "<C-k>" = "cmp.mapping.scroll_docs(-4)";
      "<C-j>" = "cmp.mapping.scroll_docs(4)";
    };
  };

  # Function parameters popup
  lsp_signature-nvim = ''
    require("lsp_signature").setup {
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded"
      }
    }
  '';
}
