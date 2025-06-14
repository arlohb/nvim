{ pkgs, ... }:
{
  # TODO: Maybe in the future
  # - https://github.com/jakewvincent/mkdnflow.nvim
  # - https://github.com/iamcco/markdown-preview.nvim
  # - https://alpha2phi.medium.com/neovim-for-beginners-note-taking-writing-diagramming-and-presentation-72d301aae28

  # TODO: Maybe fix this
  # Tables really slowing down markdown editing
  # - I think this fixes it temporarily
  # - :TSBufDisable highlight

  nixvim.plugins.render-markdown = {
    enable = true;
    settings = {
      latex.enabled = false;
      win_options.conceallevel.rendered = 2;
      on.attach = { __raw = ''
        function()
          require("nabla").enable_virt({ autogen = true })
        end
      ''; };
      html.comment.conceal = false;
    };
  };

  nixvim.plugins.nabla.enable = true;

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

  image-nvim = ''
    require("image").setup {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          download_remote_images = true,
          clear_in_insert_mode = false,
        },
      },
      max_width = 35,
      window_overlap_clear_enabled = true,
    }
  '';

  vim-table-mode = "";

  custom.lecture-notes-nvim = ''
    require("lecture-notes").setup {
      vault_location = "~/Nextcloud/Vault/Scratch.md",
      moodle_simple_dl_exe = "~/code/moodle-simple-dl/moodle-simple-dl",
    }
  '';

  nixvim.extraPackages = with pkgs; [
    # Required by image.nvim for pdfs
    ghostscript
    # Required by lecture-notes.nvim for YouTube downloads
    yt-dlp
    ffmpeg
  ];
}
