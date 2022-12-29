local M = {
  "ibhagwan/fzf-lua",

  keys = {
    {
      "<leader>b",
      function()
        require("fzf-lua").buffers()
      end,
    },
    {
      "<leader>f",
      function()
        require("fzf-lua").git_files()
      end,
    },
    {
      "<leader>g",
      function()
        require("fzf-lua").git_status()
      end,
    },
    {
      "<leader>d",
      function()
        require("fzf-lua").files()
      end,
    },
    -- { "<leader>k", ":call Wiki()<CR>"},
  },
}

local specs = { M, "nvim-tree/nvim-web-devicons" }

return specs
