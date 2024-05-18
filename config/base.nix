{ pkgs, lib, ... }:
with pkgs.vimPlugins; {
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
}
