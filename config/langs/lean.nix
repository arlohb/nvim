{ pkgs, custom, ... }:
let
  # Keeping this in case it's needed in the future
  lean3 = {
    enable = true;
    package = custom.lean3-nvim;
    leanPackage = pkgs.lean;

    settings.lsp.enable = false;
    settings.lsp3 = {
      cmd = [ "npm" "exec" "lean-language-server" "--" "--stdio" "-M" "4096" "-T" "100000" ];
      filetypes = [ "lean" "lean3" ];
    };
  };

  lean4 = {
    enable = true;
    settings.lsp.enable = true;
  };
in {
  nixvim.plugins.lean = lean4;

  # Allow lean package to be handled by elan and lake
  nixvim.dependencies.lean.enable = false;
}
