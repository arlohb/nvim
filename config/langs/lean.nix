{ pkgs, custom, ... }:
let
  # Keeping this in case it's needed in the future
  lean3 = {
    enable = true;
    package = custom.lean3-nvim;
    leanPackage = pkgs.lean;

    lsp.enable = false;
    lsp3 = {
      cmd = [ "npm" "exec" "lean-language-server" "--" "--stdio" "-M" "4096" "-T" "100000" ];
      filetypes = [ "lean" "lean3" ];
    };
  };

  lean4 = {
    enable = true;
    lsp.enable = true;
    # Allow lean package to be handled by elan and lake
    leanPackage = null;
  };
in {
  nixvim.plugins.lean = lean4;
}
