local group = vim.api.nvim_create_augroup("config.autocmds", {})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "yaml",
  desc = "Disable spell checking",
  callback = function()
    vim.opt_local.spell = false
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Briefly highlight yanked text",
  callback = function()
    vim.hl.on_yank()
  end,
})
