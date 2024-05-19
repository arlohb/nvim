{
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
