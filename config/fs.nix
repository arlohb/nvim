{ pkgs, ... }:
{
  # The file tree
  nvim-tree-lua = ''
    require("nvim-tree").setup {
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      renderer = {
        group_empty = true,
      },
    }
  '';

  # Edit filesystem like text
  oil-nvim = ''
    require("oil").setup {}
  '';
}
