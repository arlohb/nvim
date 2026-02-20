{ pkgs, vscode, ... }:
let
    ifNotVscode = x: if vscode then "" else x;
in {
    which-key-nvim = { __raw = ''

-- Documentation is here:
-- https://github.com/folke/which-key.nvim
require("which-key").setup {
    win = {
        wo = {
            winblend = 0,
        },
    },
    spec = {
        { ";", "<cmd>norm gcc<cr>", desc = "Comment new" },
        { ";", "<cmd>norm gc<cr>", desc = "Comment new", mode = "v" },

        { "<leader><leader>", function()
            require("telescope.builtin").find_files({
                find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}
            )
        end, desc = "Find Project File" },
        { "<leader>:", "<cmd>Telescope commands<cr>", desc = "Commands" },
        ${ifNotVscode ''{ "<leader>;", require("notify").dismiss, desc = "Dismiss notifications" },''}

        -- Moving between windows
        { "<C-h>", "<C-w>h", desc = "Go Left" },
        { "<C-l>", "<C-w>l", desc = "Go Right" },
        { "<C-j>", "<C-w>j", desc = "Go Down" },
        { "<C-k>", "<C-w>k", desc = "Go Up" },
        -- Quit the terminal while inside it
        { "<Esc>", "<cmd>ToggleTerm direction=float<cr>", desc = "Quit Terminal", mode = "t" },

        { "<leader>f", group = "+file" },
        { "<leader>ff", function()
            require("telescope.builtin").find_files({
                find_command = {'rg', '--files', '--hidden', '--no-ignore', '-g', '!.git' }}
            )
        end, desc = "Find Any File" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
        { "<leader>fp", "<cmd>Telescope project<cr>", desc = "Projects" },
        { "<leader>fs", "<cmd>SudaRead<cr>", desc = "Sudo current file" },
        { "<leader>fl", "<cmd>NvimTreeFindFile<cr>", desc = "Locate current file" },
        { "<leader>fe", "<cmd>Oil<cr>", desc = "Edit as Buffer (Oil)" },

        { "<leader>s", group = "+search" },
        { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search File" },
        { "<leader>sp", "<cmd>Telescope live_grep<cr>", desc = "Search Project" },
        { "<leader>s[", "<cmd>Telescope resume<cr>", desc = "Resume Search" },
        { "<leader>se", "<cmd>Telescope symbols<cr>", desc = "Emojis" },
        { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
        { "<leader>sm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
        { "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Colourscheme" },
        { "<leader>sr", "<cmd>Telescope registers<cr>", desc = "Registers" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },

        { "<leader>w", group = "+window" },
        { "<leader>wh", "<cmd>vsplit<cr>", desc = "Split Horizontal" },
        { "<leader>wv", "<cmd>split<cr>", desc = "Split Vertical" },
        { "<leader>wd", "<cmd>w|%bdelete|edit #|normal`\"<cr>", desc = "Kill all other buffers"},

        { "<leader>c", group = "+code" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
        { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
        { "<leader>cR", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        { "<leader>ci", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
        { "<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols" },
        { "<leader>cS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Project Symbols" },
        { "<leader>cd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },

        { "<leader>g", group = "+git" },
        ${ifNotVscode ''{ "<leader>gg", require("neogit").open, desc = "NeoGit" },''}
        { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff" },
        { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Status" },
        { "<leader>gS", "<cmd>Telescope git_stash<cr>", desc = "Stashes" },
        { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
        { "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "File Commits" },
        { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame Line"},
        { "<leader>gB", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
        { "<leader>ga", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage" },
        { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage" },
        { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview" },
        { "<leader>gx", "<cmd>Gitsigns reset_hunk<cr>", desc = "Discard" },

        ${ifNotVscode ''{ "<leader>o", group = "+open" },''}
        ${ifNotVscode ''{ "<leader>op", "<cmd>NvimTreeToggle<cr>", desc = "File Tree" },''}
        ${ifNotVscode ''{ "<leader>ot", "<cmd>ToggleTerm 1 direction=float<cr>", desc = "Terminal Float" },''}
        ${ifNotVscode ''{ "<leader>oT", "<cmd>ToggleTerm 2 direction=vertical<cr>", desc = "Terminal Bar" },''}
        ${ifNotVscode ''{ "<leader>ol", "<cmd>LspInfo<cr>", desc = "Lsp Info" },''}
        ${ifNotVscode ''{ "<leader>on", "<cmd>Telescope notify<cr>", desc = "Notifications" },''}

        { "<leader>d", group = "+debug" },
        ${ifNotVscode ''{ "<leader>dc", require("dap").continue, desc = "Continue" },''}
        ${ifNotVscode ''{ "<leader>dl", require("dap").step_over, desc = "Step over" },''}
        ${ifNotVscode ''{ "<leader>dj", require("dap").step_into, desc = "Step into" },''}
        ${ifNotVscode ''{ "<leader>dk", require("dap").step_out, desc = "Step out" },''}
        ${ifNotVscode ''{ "<leader>db", require("dap").toggle_breakpoint, desc = "Toggle Breakpoint" },''}
        { "<leader>dr", "<cmd>RustRunnables<cr>", desc = "Runnables" },
        { "<leader>dd", "<cmd>RustDebuggables<cr>", desc = "Debuggables" },

        { "<leader>n", group = "+notes" },
        ${ifNotVscode ''{ "<leader>nn", require("lecture-notes").open_vault, desc = "Open Vault" },''}
        { "<leader>nc", "gg/incomplete<cr>Daunchecked<esc>", desc = "Complete Note" },
        { "<leader>nC", "gg/unchecked<cr>2x", desc = "Check Note" },
        ${ifNotVscode ''{ "<leader>nl", require("lecture-notes").next_lecture, desc = "Next Lecture" },''}
        ${ifNotVscode ''{ "<leader>nh", require("lecture-notes").prev_lecture, desc = "Previous Lecture" },''}
        ${ifNotVscode ''{ "<leader>nk", require("lecture-notes").parent_module, desc = "This Module" },''}
        ${ifNotVscode ''{ "<leader>nd", require("lecture-notes").download_linked, desc = "Moodle Download Linked" },''}
        ${ifNotVscode ''{ "<leader>nD", require("lecture-notes").download, desc = "Moodle Download" },''}

        { "<leader>z", group = "+spellcheck" },
        { "<leader>zg", "zg", desc = "Good word" },
        { "<leader>zG", "zw", desc = "Bad word" },
        { "<leader>zl", "]s", desc = "Next issue" },
        { "<leader>zh", "[s", desc = "Prev issue" },
        { "<leader>zz", function()
            vim.opt.spell = not(vim.opt.spell:get())
        end, desc = "Toggle" },
    },
}

-- TODO: Move these into the which key config ?

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "J", vim.diagnostic.open_float, { desc = "Diagnostic hover" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { desc = "Goto type definition" })

-- Makes j and k when line wraps nicer
-- https://www.reddit.com/r/vim/comments/2k4cbr/comment/clhv03p
vim.cmd[[nnoremap <expr> k v:count == 0 ? 'gk' : 'k']]
vim.cmd[[nnoremap <expr> j v:count == 0 ? 'gj' : 'j']]

    ''; }.__raw;
}
