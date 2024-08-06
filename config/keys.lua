function open_file(path)
    -- Sub the ' ' for '\ '
    path = path:gsub(" ", "\\ ")

    -- Create the cmd
    local cmd = "<cmd>e " .. path .. "<cr>"

    -- Run the cmd
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(cmd, true, true, true),
        "n", true
    )
end

-- Documentation is here:
-- https://github.com/folke/which-key.nvim
require("which-key").setup {
    win = {
        wo = {
            winblend = 0,
        },
    },
    spec = {
        { "<leader><leader>", function()
            require("telescope.builtin").find_files({
                find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}
            )
        end, desc = "Find File" },
        { "<leader>:", "<cmd>Telescope commands<cr>", desc = "Commands" },
        { "<leader>;", require("notify").dismiss, desc = "Dismiss notifications" },

        -- Moving between windows
        { "<C-h>", "<C-w>h", desc = "Go Left" },
        { "<C-l>", "<C-w>l", desc = "Go Right" },
        { "<C-j>", "<C-w>j", desc = "Go Down" },
        { "<C-k>", "<C-w>k", desc = "Go Up" },
        -- Quit the terminal while inside it
        { "<Esc>", "<cmd>ToggleTerm direction=float<cr>", desc = "Quit Terminal", mode = "t" },

        { "<leader>f", group = "+file" },
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

        { "<leader>c", group = "+code" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
        { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
        { "<leader>cR", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        { "<leader>ci", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
        { "<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols" },
        { "<leader>cS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Project Symbols" },
        { "<leader>cd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },

        { "<leader>g", group = "+git" },
        { "<leader>gg", require("neogit").open, desc = "NeoGit" },
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

        { "<leader>o", group = "+open" },
        { "<leader>op", "<cmd>NvimTreeToggle<cr>", desc = "File Tree" },
        { "<leader>ot", "<cmd>ToggleTerm 1 direction=float<cr>", desc = "Terminal Float" },
        { "<leader>oT", "<cmd>ToggleTerm 2 direction=vertical<cr>", desc = "Terminal Bar" },
        { "<leader>ol", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        { "<leader>on", "<cmd>Telescope notify<cr>", desc = "Notifications" },

        { "<leader>d", group = "+debug" },
        { "<leader>dc", require("dap").continue, desc = "Continue" },
        { "<leader>dl", require("dap").step_over, desc = "Step over" },
        { "<leader>dj", require("dap").step_into, desc = "Step into" },
        { "<leader>dk", require("dap").step_out, desc = "Step out" },
        { "<leader>db", require("dap").toggle_breakpoint, desc = "Toggle Breakpoint" },
        { "<leader>dr", "<cmd>RustRunnables<cr>", desc = "Runnables" },
        { "<leader>dd", "<cmd>RustDebuggables<cr>", desc = "Debuggables" },

        { "<leader>n", group = "+notes" },
        { "<leader>nn", function()
            vim.cmd("e ~/Nextcloud/Vault/Scratch.md")
            require("telescope.builtin").find_files({
                find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}
            )
        end, desc = "Open Vault" },
        { "<leader>nc", "gg/incomplete<cr>Daunchecked<esc>", desc = "Complete Note" },
        { "<leader>nC", "gg/unchecked<cr>2x", desc = "Check Note" },
        { "<leader>nl", function()
            -- Get the current file
            local path = vim.fn.expand("%")
            -- Find the position of the last slash
            local last_slash = path:find("/[^/]*$")
            -- Get the pos of first space in file name
            local first_space = last_slash + path:sub(last_slash + 1):find(' ')
            -- Get the lecture number and add 1
            local lecture_number = tonumber(path:sub(first_space + 1, first_space + 2)) + 1
            -- Add the new lecture number to the path
            path = path:sub(0, first_space) .. string.format("%02d", lecture_number)

            open_file(path .. "*")
        end, desc = "Next Lecture" },
        { "<leader>nh", function()
            -- Get the current file
            local path = vim.fn.expand("%")
            -- Find the position of the last slash
            local last_slash = path:find("/[^/]*$")
            -- Get the pos of first space in file name
            local first_space = last_slash + path:sub(last_slash + 1):find(' ')
            -- Get the lecture number and add 1
            local lecture_number = tonumber(path:sub(first_space + 1, first_space + 2)) - 1
            -- Add the new lecture number to the path
            path = path:sub(0, first_space) .. string.format("%02d", lecture_number)

            open_file(path .. "*")
        end, desc = "Previous Lecture" },
        { "<leader>nk", function()
            -- Get the current file
            local path = vim.fn.expand("%")
            -- Find the position of the last slash
            local last_slash = path:find("/[^/]*$")
            -- Add the lecture number "00" to the path
            path = path:sub(0, last_slash + 5) .. "00.md"

            open_file(path)
        end, desc = "This Module" },

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

-- TODO: Switch to 'gcc' and 'gc' as native support was added in nvim 0.10
vim.keymap.set("n", ";", "<cmd>Commentary<cr>", { desc = "Comment" })
vim.keymap.set("v", ";", ":'<,'>Commentary<cr>", { desc = "Comment" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "J", vim.diagnostic.open_float, { desc = "Diagnostic hover" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { desc = "Goto type definition" })

-- Makes j and k when line wraps nicer
-- https://www.reddit.com/r/vim/comments/2k4cbr/comment/clhv03p
vim.cmd[[nnoremap <expr> k v:count == 0 ? 'gk' : 'k']]
vim.cmd[[nnoremap <expr> j v:count == 0 ? 'gj' : 'j']]

