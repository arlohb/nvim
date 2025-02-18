{ pkgs, ... }:
{
  hls = {
    enable = true;
    filetypes = [ "haskell" "lhaskell" "cabal" ];
    installGhc = false;
  };
}

