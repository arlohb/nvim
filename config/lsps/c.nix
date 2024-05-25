{ pkgs, ... }:
{
  # TODO: One fails every time a file opens
  ccls.enable = true;
  clangd.enable = true;
}
