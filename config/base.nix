{ pkgs, vscode, ... }:
{
  none = builtins.readFile ./base.lua;

  # Required by loads of plugins
  plenary-nvim = "";
  nvim-web-devicons = "";

} // (if vscode then {} else {

  # A terminal that can be floating or as a side pane
  toggleterm-nvim = ''
    require("toggleterm").setup({
      autochdir = true,
      shade_terminals = false,
      float_opts = {
        border = "curved",
        winblend = 0,
      },
    })
  '';

  # Integrates with direnv
  # Not required in vscode because this is really only used to download LSPs
  direnv-vim = ''
    -- This is my own variable not direnv's
    -- I want to ignore the first time (when nvim starts),
    -- and only notify the second time.
    vim.g.direnv_already_notified = -1

    vim.g.direnv_silent_load = 1

    vim.api.nvim_create_autocmd(
      "User",
      {
        pattern = "DirenvLoaded",
        callback = function(_e)
          if vim.g.direnv_already_notified == 0 then
            vim.notify("Direnv loaded")
          end

          -- Lua doesn't have ++ or += 😞
          vim.g.direnv_already_notified = vim.g.direnv_already_notified + 1
        end,
      }
    )
  '';
})
