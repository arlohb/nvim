local platform = require("config.platform")

--- Find files with ripgrep, including hidden ones but not .git
---@param no_ignore boolean Also show files ignored by .gitignore
local function find_files(no_ignore)
  return function()
    local cmd = { "rg", "--files", "--hidden", "-g", "!.git" }
    if no_ignore then
      table.insert(cmd, "--no-ignore")
    end
    require("telescope.builtin").find_files({ find_command = cmd })
  end
end

local keys = {
  { "<leader><leader>", find_files(false), desc = "Find Project File" },
  { "<leader>:", "<cmd>Telescope commands<cr>", desc = "Commands" },

  { "<leader>ff", find_files(true), desc = "Find Any File" },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
  { "<leader>fp", "<cmd>Telescope project<cr>", desc = "Projects" },

  { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search File" },
  { "<leader>sp", "<cmd>Telescope live_grep<cr>", desc = "Search Project" },
  { "<leader>s[", "<cmd>Telescope resume<cr>", desc = "Resume Search" },
  { "<leader>se", "<cmd>Telescope symbols<cr>", desc = "Emojis" },
  { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
  { "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Colourscheme" },
  { "<leader>sr", "<cmd>Telescope registers<cr>", desc = "Registers" },
  { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },

  { "<leader>cR", "<cmd>Telescope lsp_references<cr>", desc = "References" },
  { "<leader>ci", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
  { "<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols" },
  { "<leader>cS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Project Symbols" },
  { "<leader>cd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },

  { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Status" },
  { "<leader>gS", "<cmd>Telescope git_stash<cr>", desc = "Stashes" },
  { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
  { "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "File Commits" },
  { "<leader>gB", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
}

if not platform.is_windows then
  table.insert(keys, { "<leader>sm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" })
end

-- Needs ripgrep (rg) and fd on PATH
---@type LazySpec
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = keys,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-symbols.nvim",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        pickers = {
          colorscheme = { enable_preview = true },
        },
      })
      telescope.load_extension("file_browser")
      telescope.load_extension("project")
    end,
  },
}
