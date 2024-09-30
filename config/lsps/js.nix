{ pkgs, ... }:
{
  ts-ls = {
    enable = true;
    settings = {
      typescript.format.enable = false;
      javascript.format.enable = false;
    };
  };

  html.enable = true;

  svelte = {
    enable = true;

    onAttach.function = ''
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    '';

    settings.svelte.enable-ts-plugin = true;
  };

  eslint.enable = true;

  tailwindcss = {
    enable = true;
    cmd = [ "npm" "exec" "tailwindcss-language-server" "--stdio" ];
  };

  cssls.enable = true;

  denols.enable = true;
}
