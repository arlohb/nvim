local opt = vim.opt
local g = vim.g

-- Make the leader key <space>
g.mapleader = ' '

-- Gui
opt.guifont = { "FiraCode Nerd Font SemBd", "h10" }
opt.winblend = 0

-- Always use the system clipboard
opt.clipboard = "unnamedplus"

-- Context
opt.number = true -- bool: Show line numbers
opt.relativenumber = true -- bool: Show relative line numbers
opt.scrolloff = 12 -- int:  Min num lines of context
opt.signcolumn = "yes" -- str:  Show the sign column

-- Filetypes
opt.encoding = 'utf8' -- str:  String encoding to use
opt.fileencoding = 'utf8' -- str:  File encoding to use

-- Theme
opt.syntax = "ON" -- str:  Allow syntax highlighting
opt.termguicolors = true -- bool: If term supports ui color then enable

-- Search
opt.ignorecase = true -- bool: Ignore case in search patterns
opt.smartcase = true -- bool: Override ignorecase if search contains capitals
opt.incsearch = true -- bool: Use incremental search
opt.hlsearch = false -- bool: Highlight search matches

-- Whitespace
opt.expandtab = true -- bool: Use spaces instead of tabs
opt.shiftwidth = 4 -- num:  Size of an indent
opt.softtabstop = 4 -- num:  Number of spaces tabs count for in insert mode
opt.tabstop = 4 -- num:  Number of spaces tabs count for

-- Line at 80 char
opt.colorcolumn = "80"
-- Turn off line wrapping
vim.wo.wrap = false

-- Splits
opt.splitright = true -- bool: Place new window to right of current one
opt.splitbelow = true -- bool: Place new window below the current one

-- Make whichkey show up faster
opt.timeoutlen = 200

-- Enable spell checking
-- TODO: https://www.reddit.com/r/neovim/comments/nbbl5w/comment/gxz560o
opt.spell = true
opt.spelllang = "en_gb"
opt.spellfile = vim.fn.expand("~/.config/nvim/spell/en.utf-8.add")

-- Disable spellchecking for yaml
vim.api.nvim_create_autocmd("FileType", {
    pattern = "yaml",
    callback = function()
        vim.opt_local.spell = false
    end
})

