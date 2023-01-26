local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
}

function M.config()
  require("gitsigns").setup({
    signs = {
      add = {
        text = "│",
      },
      change = {
        text = "│",
      },
      delete = {
        text = "_",
      },
      topdelete = {
        text = "‾",
      },
      changedelete = {
        text = "~",
      },
    },
    current_line_blame_opts = {
      delay = 150,
    },
    on_attach = function(buffer)
      require("edwlarkey.keymaps").setup.gitsigns(buffer)
    end,
  })
end

return M
