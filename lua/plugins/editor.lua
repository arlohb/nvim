local platform = require("config.platform")

--- Toggle a terminal. `count` tells terminals apart, so the float and the
--- side pane are separate shells.
---@param count integer
---@param position "float"|"right"
local function terminal(count, position)
  return function()
    Snacks.terminal.toggle(nil, { count = count, win = { position = position } })
  end
end

---@type LazySpec
return {
  -- Shows pending mappings
  {
    "folke/which-key.nvim",
    vscode = true,
    event = "VeryLazy",
    opts = {
      win = { wo = { winblend = 0 } },
      spec = {
        { "<leader>c", group = "+code" },
        { "<leader>d", group = "+debug" },
        { "<leader>f", group = "+file" },
        { "<leader>g", group = "+git" },
        { "<leader>n", group = "+notes" },
        { "<leader>o", group = "+open" },
        { "<leader>s", group = "+search" },
        { "<leader>w", group = "+window" },
        { "<leader>z", group = "+spellcheck" },
      },
    },
  },

  -- Better word movements
  {
    "chrisgrieser/nvim-spider",
    vscode = true,
    opts = { skipInsignificantPunctuation = false },
    keys = vim.tbl_map(function(motion)
      return {
        motion,
        function()
          require("spider").motion(motion)
        end,
        mode = { "n", "o", "x" },
        desc = "Spider-" .. motion,
      }
    end, { "w", "e", "b", "ge" }),
  },

  -- Jump anywhere on screen
  {
    "folke/flash.nvim",
    vscode = true,
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", function() require("flash").jump() end, mode = { "n", "o", "x" }, desc = "Flash" },
      { "S", function() require("flash").treesitter() end, mode = { "n", "o", "x" }, desc = "Flash Treesitter" },
      { "r", function() require("flash").remote() end, mode = "o", desc = "Remote Flash" },
      { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Treesitter Search" },
    },
  },

  -- Autopair brackets and other stuff
  {
    "windwp/nvim-autopairs",
    vscode = true,
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      npairs.setup({})
      npairs.add_rule(Rule("<", ">"):with_move(cond.move_right):with_pair(cond.not_before_regex(" ")))
    end,
  },

  -- Surround selections
  { "kylechui/nvim-surround", vscode = true, event = "VeryLazy", opts = {} },

  -- Detect indentation, and read editorconfig
  { "tpope/vim-sleuth", vscode = true },

  -- Highlight TODO, FIXME, NOTE etc. comments
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TodoTelescope" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "TODOs" },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next TODO",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous TODO",
      },
    },
    opts = {},
  },

  -- snacks.nvim's base spec is in ui.lua
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>ot", terminal(1, "float"), desc = "Terminal Float" },
      { "<leader>oT", terminal(2, "right"), desc = "Terminal Bar" },
    },
    ---@type snacks.Config
    opts = {
      -- Smooth scrolling, slower than snacks' default (200ms, linear)
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 10, total = 600 },
          easing = "outQuad",
        },
        -- Used when scrolling again within `delay` ms, e.g. holding <C-d>
        animate_repeat = {
          delay = 100,
          duration = { step = 5, total = 100 },
          easing = "outQuad",
        },
      },
      -- A terminal that can be floating or a side pane
      terminal = {
        shell = platform.is_windows and (platform.has("pwsh") and "pwsh" or "powershell") or nil,
        win = {
          border = "rounded",
          keys = {
            -- Hide the terminal straight away, rather than leaving
            -- terminal mode on a double <Esc>
            term_normal = false,
            hide = { "<Esc>", "hide", mode = "t", desc = "Quit Terminal" },
          },
        },
      },
    },
  },

  -- Loads each project's .envrc, which is where LSP servers come from on Nix.
  -- direnv doesn't run natively on Windows.
  {
    "direnv/direnv.vim",
    cond = not platform.is_vscode and platform.has("direnv"),
    init = function()
      vim.g.direnv_silent_load = 1

      -- Ignore the first load (at startup), and only notify on the second
      local loads = 0
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("config.direnv", {}),
        pattern = "DirenvLoaded",
        callback = function()
          if loads == 1 then
            vim.notify("Direnv loaded")
          end
          loads = loads + 1
        end,
      })
    end,
  },
}
