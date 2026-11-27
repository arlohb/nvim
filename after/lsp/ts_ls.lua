---@type vim.lsp.Config
return {
  settings = {
    -- Don't format with ts_ls
    typescript = { format = { enable = false } },
    javascript = { format = { enable = false } },
  },
}
