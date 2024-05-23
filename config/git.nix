{ pkgs, ... }:
{
  nixvim = {
    extraPackages = with pkgs; [
      # Is probably installed, but just to be sure
      git
    ];
  };

  # Magit clone
  neogit = ''
    require("neogit").setup {
      kind = "replace",
    }
  '';

  # An integration for neogit
  diffview-nvim = "";

  # Git diffs in file
  gitsigns-nvim = ''
    require("gitsigns").setup()
  '';
}
