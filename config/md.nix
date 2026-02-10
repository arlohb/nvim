{ pkgs, ... }:
{
  nixvim.plugins.snacks = {
    enable = true;
    settings.image = {
      enable = true;
      doc.max_width = 40;
      doc.max_height = 40;
    };
  };

  mkdnflow-nvim = ''
    require("mkdnflow").setup {
      modules = {
        bib = false,
        maps = false,
        -- TODO maybe change to this from vim-table-mode
        tables = false,
      },
      perspective = {
        priority = "root",
        root_tell = "Scratch.md"
      },
      links = {
        style = "wiki",
        conceal = true,
        transform_implicit = function(input)
          -- If path is http(s):// or file:
          if input:find(":") then
            return input
          end

          return "**/"..input..".md"
        end,
      },
      create_dirs = false,
    }

    vim.keymap.set("n", "gf", "<cmd>MkdnEnter<cr>")
  '';

  vim-table-mode = "";

  custom.lecture-notes-nvim = ''
    require("lecture-notes").setup {
      vault_location = "~/Nextcloud/Vault/Scratch.md",
      moodle_simple_dl_exe = "~/code/moodle-simple-dl/moodle-simple-dl",
    }
  '';

  nixvim.extraPackages = with pkgs; [
    # Required by lecture-notes.nvim for YouTube downloads
    yt-dlp
    ffmpeg
    # Required by snacks.nvim image module for Latex rendering
    tectonic # This is apparently faster
    ghostscript
  ];
}
