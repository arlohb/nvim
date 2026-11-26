local opt = vim.opt

-- Must be set before lazy.nvim loads any plugin mappings
vim.g.mapleader = " "

-- GUI clients (e.g. Neovide)
opt.guifont = "FiraCode Nerd Font SemBd:h10"

-- Use the system clipboard. Scheduled because finding a clipboard provider
-- can be slow (especially on WSL) and would delay startup.
vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)

-- Context
opt.number = true
opt.relativenumber = true
opt.scrolloff = 12
opt.signcolumn = "yes"
opt.colorcolumn = "80"
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true -- Unless the pattern contains capitals
opt.hlsearch = false

-- Indentation (vim-sleuth adjusts these per file)
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Keep undo history after closing a file (in stdpath("state")/undo)
opt.undofile = true

-- Make which-key show up faster
opt.timeoutlen = 200

-- Spell checking
-- TODO: https://www.reddit.com/r/neovim/comments/nbbl5w/comment/gxz560o
opt.spell = true
opt.spelllang = "en_gb"
opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

-- HLSL is close enough to C++ for highlighting
vim.filetype.add({ extension = { hlsl = "cpp" } })
