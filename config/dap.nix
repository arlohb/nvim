{ pkgs, ... }:
{
  # Not tested

  nvim-dap = "";
  nvim-dap-ui = "";
  none = ''
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup({})
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    vim.fn.sign_define("DapBreakpoint", {
      text = "🟥",
      texthl = "LspDiagnosticsSignError",
      linehl = "",
      numhl = "",
    })
  '';

  # DAP telescope
  telescope-dap-nvim = ''
    require("telescope").load_extension("dap")
  '';

  nvim-dap-virtual-text = ''
    require("nvim-dap-virtual-text").setup {
       commented = true,
    }
  '';
}
