local M = {
  "mfussenegger/nvim-dap",

  dependencies = {
    {
      "rcarriga/nvim-dap-ui",

      config = function()
        require("dapui").setup()
      end,
    },
    { "nvim-neotest/nvim-nio" },
    { "leoluz/nvim-dap-go" },
  },
}

function M.init()
  vim.keymap.set("n", "<leader>bb", function()
    require("dap").toggle_breakpoint()
  end, { desc = "Toggle Breakpoint" })

  vim.keymap.set("n", "<leader>bc", function()
    require("dap").continue()
  end, { desc = "Continue" })

  vim.keymap.set("n", "<leader>bo", function()
    require("dap").step_over()
  end, { desc = "Step Over" })

  vim.keymap.set("n", "<leader>bi", function()
    require("dap").step_into()
  end, { desc = "Step Into" })

  vim.keymap.set("n", "<leader>bw", function()
    require("dap.ui.widgets").hover()
  end, { desc = "Widgets" })

  vim.keymap.set("n", "<leader>br", function()
    require("dap").repl.open()
  end, { desc = "Repl" })

  vim.keymap.set("n", "<leader>bu", function()
    require("dapui").toggle({})
  end, { desc = "Dap UI" })
end

function M.config()
  local dap = require("dap")

  require("dap-go").setup({
    -- Additional dap configurations can be added.
    -- dap_configurations accepts a list of tables where each entry
    -- represents a dap configuration. For more details do:
    -- :help dap-configuration
    dap_configurations = {
      {
        -- Must be "go" or it will be ignored by the plugin
        type = "go",
        name = "Attach remote",
        mode = "remote",
        request = "attach",
      },
    },
    -- delve configurations
    delve = {
      -- time to wait for delve to initialize the debug session.
      -- default to 20 seconds
      initialize_timeout_sec = 20,
      -- a string that defines the port to start delve debugger.
      -- default to string "${port}" which instructs nvim-dap
      -- to start the process in a random available port
      port = "${port}",
    },
  })

  local dapui = require("dapui")
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({})
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close({})
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close({})
  end
end

-- - `DapBreakpoint` for breakpoints (default: `B`)
-- - `DapBreakpointCondition` for conditional breakpoints (default: `C`)
-- - `DapLogPoint` for log points (default: `L`)
-- - `DapStopped` to indicate where the debugee is stopped (default: `→`)
-- - `DapBreakpointRejected` to indicate breakpoints rejected by the debug
--   adapter (default: `R`)
--
-- You can customize the signs by setting them with the |sign_define()| function.
-- For example:
--
-- >
--     lua << EOF
--     vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
--     EOF
-- <

return M
