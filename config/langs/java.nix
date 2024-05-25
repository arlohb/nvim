{ pkgs, ... }:
{
  none = ''
    require("lspconfig").jdtls.setup {}
  '';
}

