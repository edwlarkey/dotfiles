require("indent_blankline").setup {
  show_current_context = true,
  show_current_context_start = true,
  show_trailing_blankline_indent = false,
  use_treesitter = true,
  filetype_exclude = {
    "help",
  },
}

require('gitsigns').setup({
  signs = {
    add = {
      text = "│",
    },
    change = {
      text = "│",
    },
    delete = {
      text = "│",
    },
    topdelete = {
      text = "│",
    },
    changedelete = {
      text = "│",
    },
  },
  current_line_blame_opts = {
    delay = 150,
  },
  on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]c", function()
          if vim.wo.diff then
              return "]c"
          end
          vim.schedule(function()
              gs.next_hunk()
          end)
          return "<Ignore>"
      end, { expr = true, desc = "Next change" })

      map("n", "[c", function()
          if vim.wo.diff then
              return "[c"
          end
          vim.schedule(function()
              gs.prev_hunk()
          end)
          return "<Ignore>"
      end, { expr = true, desc = "Previous change" })

      -- Actions
      map("n", "<Leader>hb", function()
          gs.blame_line()
      end)
      map("n", "<Leader>hB", function()
          gs.blame_line({ full = true })
      end)
      map("n", "<Leader>hD", function()
          gs.diffthis("~")
      end)
      map("n", "<Leader>hd", gs.diffthis, { desc = "Diff this" })
      map("n", "<Leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
  end,
})
require("scrollbar").setup()
require("scrollbar.handlers.gitsigns").setup()
