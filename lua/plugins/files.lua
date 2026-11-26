---@type LazySpec
return {
  -- Edit the filesystem like a buffer. Not lazy-loaded, so it opens when
  -- Neovim is started on a directory.
  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
      { "<leader>fe", "<cmd>Oil<cr>", desc = "Edit as Buffer (Oil)" },
    },
    opts = {},
  },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeOpen" },
    keys = {
      { "<leader>op", "<cmd>NvimTreeToggle<cr>", desc = "File Tree" },
      { "<leader>fl", "<cmd>NvimTreeFindFile<cr>", desc = "Locate current file" },
    },
    opts = {
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      renderer = {
        group_empty = true,
      },
    },
  },
}
