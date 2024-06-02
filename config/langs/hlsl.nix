{ pkgs, ... }:
{
  none = ''
    vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
      pattern = {"*.hlsl"},
      callback = function() vim.cmd("set filetype=cpp") end,
    })
  '';
}
