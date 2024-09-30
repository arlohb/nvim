{ pkgs, custom, ... }:
{
  nixvim.plugins.lean = {
    enable = true;
    package = custom.lean3-nvim;
    leanPackage = pkgs.lean;

    lsp.enable = false;
    lsp3 = {
      cmd = [ "npm" "exec" "lean-language-server" "--" "--stdio" "-M" "4096" "-T" "100000" ];
      filetypes = [ "lean" "lean3" ];
    };
  };
}
