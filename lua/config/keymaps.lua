-- Mappings that don't belong to a plugin. Plugin mappings live in the
-- plugin's spec (`keys = ...`), so the plugin loads when they're pressed.
-- which-key group names are in lua/plugins/editor.lua.

local map = vim.keymap.set

-- Comments (built in since Neovim 0.10)
map("n", ";", "gcc", { remap = true, desc = "Toggle comment" })
map("x", ";", "gc", { remap = true, desc = "Toggle comment" })

-- Move by display line when a line wraps, unless given a count
-- https://www.reddit.com/r/vim/comments/2k4cbr/comment/clhv03p
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "Go Left" })
map("n", "<C-l>", "<C-w>l", { desc = "Go Right" })
map("n", "<C-j>", "<C-w>j", { desc = "Go Down" })
map("n", "<C-k>", "<C-w>k", { desc = "Go Up" })
map("n", "<leader>wh", "<cmd>vsplit<cr>", { desc = "Split Horizontal" })
map("n", "<leader>wv", "<cmd>split<cr>", { desc = "Split Vertical" })
map("n", "<leader>wd", '<cmd>w|%bdelete|edit #|normal`"<cr>', { desc = "Kill all other buffers" })

-- Diagnostics
map("n", "J", vim.diagnostic.open_float, { desc = "Diagnostic hover" })

-- Spell checking
map("n", "<leader>zg", "zg", { desc = "Good word" })
map("n", "<leader>zG", "zw", { desc = "Bad word" })
map("n", "<leader>zl", "]s", { desc = "Next issue" })
map("n", "<leader>zh", "[s", { desc = "Prev issue" })
map("n", "<leader>zz", function()
  vim.opt.spell = not vim.opt.spell:get()
end, { desc = "Toggle" })

-- Note checkboxes
map("n", "<leader>nc", "gg/incomplete<cr>Daunchecked<esc>", { desc = "Complete Note" })
map("n", "<leader>nC", "gg/unchecked<cr>2x", { desc = "Check Note" })
