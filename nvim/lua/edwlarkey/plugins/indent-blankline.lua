local M = {
  "lukas-reineke/indent-blankline.nvim",
  lazy = false,
  -- event = "BufReadPre",
  config = {
    show_current_context = true,
    show_current_context_start = true,
    show_trailing_blankline_indent = false,
    use_treesitter = true,
    filetype_exclude = {
      "help",
    },
  },
}

return M
