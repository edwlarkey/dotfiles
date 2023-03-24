local M = {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    --   fzf_opts = { ["--ansi"] = false },
    --   files = {
    --     git_icons = false,
    --     file_icons = false,
    --   },
    lsp = {
      -- make lsp requests synchronous so they work with null-ls
      async_or_timeout = 3000,
    },
  },
}

return M
