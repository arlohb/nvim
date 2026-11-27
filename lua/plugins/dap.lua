-- Not tested

---@param method string
local function dap(method)
  return function()
    require("dap")[method]()
  end
end

---@type LazySpec
return {
  {
    url = "https://codeberg.org/mfussenegger/nvim-dap",
    name = "nvim-dap",
    keys = {
      { "<leader>dc", dap("continue"), desc = "Continue" },
      { "<leader>dl", dap("step_over"), desc = "Step over" },
      { "<leader>dj", dap("step_into"), desc = "Step into" },
      { "<leader>dk", dap("step_out"), desc = "Step out" },
      { "<leader>db", dap("toggle_breakpoint"), desc = "Toggle Breakpoint" },
    },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      { "theHamsta/nvim-dap-virtual-text", opts = { commented = true } },
      "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
      local dapui = require("dapui")
      dapui.setup()

      -- Open the UI while debugging
      local listeners = require("dap").listeners
      -- stylua: ignore start
      listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      listeners.before.event_exited["dapui_config"] = function() dapui.close() end
      -- stylua: ignore end

      vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "DiagnosticSignError" })

      require("telescope").load_extension("dap")
    end,
  },
}
