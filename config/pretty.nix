{ pkgs, vscode, ... }:
{
  # The theme(s)
  sonokai = ''
    vim.g.sonokai_style = "andromeda"
    -- This unfortunately tried to modify the read-only filesystem,
    -- and can't be configured not to
    vim.g.sonokai_better_performance = 0
    -- vim.cmd("colorscheme sonokai")
  '';
  kanagawa-nvim = "";
  neovim-ayu = "";
  embark-vim = "";
  nightfox-nvim = "";
  jellybeans-nvim = "";
  oxocarbon-nvim = "";
  dracula-nvim = ''
    require("dracula").setup {}
    -- vim.cmd("colorscheme dracula")
  '';
  catppuccin-nvim = ''
    vim.cmd("colorscheme catppuccin")
  '';
  tokyonight-nvim = "";
  material-nvim = "";
  # TODO: Add back custom plugins
  # custom.everblush-nvim = "";

  # The status line at the bottom
  lualine-nvim = ''
    require("lualine").setup {
      options = {
        theme = "auto",
        disabled_filetypes = { "NvimTree", "alpha" },
      },
    }
  '';

  # Makes UI nicer
  dressing-nvim = ''
    require("dressing").setup {}
  '';

  # Nicer notification UI
  nvim-notify = ''
    vim.notify = require("notify")
    require("telescope").load_extension("notify")
  '';

  # Show thin lines at indents
  indent-blankline-nvim = ''
    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      -- This is using dracula colours,
      -- Which still look fine with other themes
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#FF5555" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#F1FA8C" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#8BE9FD" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#FFB86C" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#50FA7B" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#BD93F9" })
    end)

    require("ibl").setup {
      indent = {
        highlight = {
          "RainbowRed",
          "RainbowOrange",
          "RainbowYellow",
          "RainbowGreen",
          "RainbowBlue",
          "RainbowViolet",
        },
      },
      scope = {
        enabled = false,
      },
    }
  '';

} // (if vscode then {} else {

  nixvim.plugins.rainbow-delimiters = {
    enable = true;
    settings.highlight = [
      # Removing red and green make it look better
      # "RainbowRed"
      "RainbowOrange"
      "RainbowYellow"
      # "RainbowGreen"
      "RainbowBlue"
      "RainbowViolet"
    ];
  };
})
