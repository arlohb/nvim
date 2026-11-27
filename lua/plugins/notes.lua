local platform = require("config.platform")

---@param method string
local function notes(method)
  return function()
    require("lecture-notes")[method]()
  end
end

--- Resolve a wiki link like [[foo/bar]] to a markdown file under the
--- current directory.
---@param input string
---@return string?
local function find_note(input)
  -- Already a URL or file: link
  if input:find(":") then
    return input
  end

  -- With --full-path, a leading separator makes the match more specific.
  -- Windows paths use backslashes.
  local sep = platform.is_windows and [=[[\\/]]=] or "/"
  return vim.fn.systemlist({ "fd", "--full-path", sep .. input .. ".md" })[1]
end

---@type LazySpec
return {
  -- Images in markdown. Only renders in terminals with the kitty graphics
  -- protocol (kitty, WezTerm, Ghostty). LaTeX needs tectonic and ghostscript.
  -- snacks.nvim's base spec is in ui.lua.
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      image = {
        enabled = true,
        doc = {
          max_width = 80,
          max_height = 10,
        },
      },
    },
  },

  -- Wiki-style links between notes
  {
    "jakewvincent/mkdnflow.nvim",
    ft = "markdown",
    keys = {
      { "gf", "<cmd>MkdnEnter<cr>", ft = "markdown", desc = "Follow link" },
    },
    opts = {
      modules = {
        bib = false,
        maps = false,
        -- TODO maybe change to this from vim-table-mode
        tables = false,
      },
      perspective = {
        priority = "root",
        root_tell = "Scratch.md",
      },
      links = {
        style = "wiki",
        conceal = true,
        transform_implicit = find_note,
      },
      create_dirs = false,
    },
  },

  -- Markdown tables
  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    cmd = { "TableModeToggle", "TableModeEnable", "Tableize" },
  },

  -- Uni lecture notes. YouTube downloads use yt-dlp and ffmpeg.
  {
    "arlohb/lecture-notes.nvim",
    keys = {
      { "<leader>nn", notes("open_vault"), desc = "Open Vault" },
      { "<leader>nl", notes("next_lecture"), desc = "Next Lecture" },
      { "<leader>nh", notes("prev_lecture"), desc = "Previous Lecture" },
      { "<leader>nk", notes("parent_module"), desc = "This Module" },
      { "<leader>nd", notes("download_linked"), desc = "Moodle Download Linked" },
      { "<leader>nD", notes("download"), desc = "Moodle Download" },
    },
    opts = {
      vault_location = "~/Nextcloud/Vault/Scratch.md",
      moodle_simple_dl_exe = "~/code/moodle-simple-dl/moodle-simple-dl",
    },
  },
}
