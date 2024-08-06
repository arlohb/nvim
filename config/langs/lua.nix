{ pkgs, ... }:
{
  # Adds completion of neovim apis
  lazydev-nvim = ''
    require("lazydev").setup {}
  '';
}
