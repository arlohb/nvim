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

  nixvim.extraPackages = with pkgs; [
    # Required by image.vnim for pdfs
    ghostscript
  ];

  image-nvim = ''
    require("image").setup {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          download_remote_images = true,
          clear_in_insert_mode = true,
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
}
