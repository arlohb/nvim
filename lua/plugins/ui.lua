-- Highlight groups for indent guides and rainbow-delimiters (treesitter.lua).
-- Dracula's colours, which still look fine with other themes.
local rainbow = {
  RainbowRed = "#FF5555",
  RainbowOrange = "#FFB86C",
  RainbowYellow = "#F1FA8C",
  RainbowGreen = "#50FA7B",
  RainbowBlue = "#8BE9FD",
  RainbowViolet = "#BD93F9",
}

local function set_rainbow_highlights()
  for name, fg in pairs(rainbow) do
    vim.api.nvim_set_hl(0, name, { fg = fg })
  end
end

local header = [[
                            ....
                          .'' .'''
.                             .'   :
\\                          .:    :
\\                        _:    :       ..----.._
\\                    .:::.....:::.. .'         ''.
\\                 .'  #-. .-######'     #        '.
\\                 '.##'/ ' ################       :
\\                  #####################         :
\\               ..##.-.#### .''''###'.._        :
 \\             :--:########:            '.    .' :
  \\..__...--.. :--:#######.'   '.         '.     :
  :     :  : : '':'-:'':'::        .         '.  .'
  '---'''..: :    ':    '..'''.      '.        :'
     \\  :: : :     '      ''''''.     '.      .:
      \\ ::  : :     '            '.      '      :
       \\::   : :           ....' ..:       '     '.
        \\::  : :    .....####\\ .~~.:.             :
         \\':.:.:.:'#########.===. ~ |.'-.   . '''.. :
          \\    .'  ########## \ \ _.' '. '-.       '''.
          :\\  :     ########   \ \      '.  '-.        :
         :  \\'    '   #### :    \ \      :.    '-.      :
        :  .'\\   :'  :     :     \ \       :      '-.    :
       : .'  .\\  '  :      :     :\ \       :        '.   :
       ::   :  \\'  :.      :     : \ \      :          '. :
       ::. :    \\  : :      :    ;  \ \     :           '.:
        : ':    '\\ :  :     :     :  \:\     :        ..'
           :    ' \\ :        :     ;  \|      :   .'''
           '.   '  \\:                         :.''
            .:..... \\:       :            ..''
           '._____|'.\\......'''''''.:..'''
                      \\
]]

-- The dashboard centres each line separately, so pad every line to the same
-- width to keep the art's shape
local header_lines = vim.split(header, "\n")
local header_width = 0
for _, line in ipairs(header_lines) do
  header_width = math.max(header_width, vim.api.nvim_strwidth(line))
end
for i, line in ipairs(header_lines) do
  header_lines[i] = line .. string.rep(" ", header_width - vim.api.nvim_strwidth(line))
end

---@type LazySpec
return {
  -- Colour schemes. All loaded so Telescope's colourscheme picker lists them.
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "sainnhe/sonokai",
    init = function()
      vim.g.sonokai_style = "andromeda"
      vim.g.sonokai_better_performance = 1
    end,
  },
  { "Mofiqul/dracula.nvim", opts = {} },
  { "rebelot/kanagawa.nvim" },
  { "Shatur/neovim-ayu" },
  { "embark-theme/vim", name = "embark" },
  { "EdenEast/nightfox.nvim" },
  { "metalelf0/jellybeans-nvim", dependencies = { "rktjmp/lush.nvim" } },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "folke/tokyonight.nvim" },
  { "marko-cerovac/material.nvim" },

  -- Icons, used by lots of plugins
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- UI building blocks. Other modules are enabled in editor.lua (terminal,
  -- scroll) and notes.lua (image).
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<leader>;",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss notifications",
      },
      {
        "<leader>on",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notifications",
      },
    },
    init = function()
      set_rainbow_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("config.rainbow", {}),
        callback = set_rainbow_highlights,
      })
    end,
    ---@type snacks.Config
    opts = {
      -- Notification popups (replaces vim.notify)
      notifier = { enabled = true },
      -- vim.ui.input and vim.ui.select
      input = { enabled = true },
      picker = { ui_select = true },
      -- Indent guides, coloured per level
      indent = {
        enabled = true,
        indent = {
          hl = {
            "RainbowRed",
            "RainbowOrange",
            "RainbowYellow",
            "RainbowGreen",
            "RainbowBlue",
            "RainbowViolet",
          },
        },
        scope = { enabled = false },
      },
      -- Start screen
      dashboard = {
        enabled = true,
        width = header_width,
        preset = { header = table.concat(header_lines, "\n") },
        sections = { { section = "header" } },
      },
    },
  },

  -- Snow on the start screen
  {
    "folke/drop.nvim",
    opts = {
      theme = "snow",
      max = 500,
      interval = 70,
      screensaver = false,
      filetypes = { "snacks_dashboard" },
    },
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        disabled_filetypes = { "NvimTree", "snacks_dashboard" },
      },
    },
  },
}
