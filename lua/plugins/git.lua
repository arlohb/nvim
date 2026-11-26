---@type LazySpec
return {
  -- Magit clone
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "NeoGit" },
    },
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    opts = { kind = "replace" },
  },

  -- Diff and file history views, also used by neogit
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  },

  -- Git signs and hunk actions in the buffer
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff" },
      { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame Line" },
      { "<leader>ga", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage" },
      { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage" },
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview" },
      { "<leader>gx", "<cmd>Gitsigns reset_hunk<cr>", desc = "Discard" },
    },
    opts = {},
  },
}
