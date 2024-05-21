{ pkgs, ... }:
{
  # A fuzzy finder with many uses
  telescope-nvim = ''
    require("telescope").setup {
      pickers = {
        colorscheme = {
          enable_preview = true
        },
      },
    }
  '';

  # A telescope file browser
  telescope-file-browser-nvim = ''
    require("telescope").load_extension("file_browser")
  '';

  # A telescope project manager
  telescope-project-nvim = ''
    require("telescope").load_extension("project")
  '';

  # Populates the telescope symbol picker
  telescope-symbols-nvim = "";
}
