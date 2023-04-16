local mini = {
  "echasnovski/mini.nvim",
}

local specs = { mini, "JoosepAlviste/nvim-ts-context-commentstring" }

function mini.config()
  require("mini.cursorword").setup({ delay = 500 })
  -- require("mini.sessions").setup()
  require("mini.statusline").setup()
  require("mini.bracketed").setup()
  require("mini.colors").setup()
  -- require("mini.jump").setup({})
  -- require("mini.pairs").setup({})
  require("mini.comment").setup({
    hooks = {
      pre = function()
        require("ts_context_commentstring.internal").update_commentstring({})
      end,
    },
  })
  -- local starter = require("mini.starter")
  -- starter.setup({
  --   evaluate_single = false,
  --   items = {
  --     starter.sections.builtin_actions(),
  --     starter.sections.recent_files(5, false),
  --     starter.sections.recent_files(5, true),
  --     -- Use this if you set up 'mini.sessions'
  --     starter.sections.sessions(5, true),
  --   },
  --   content_hooks = {
  --     starter.gen_hook.adding_bullet(),
  --     -- starter.gen_hook.indexing('all', { 'Builtin actions' }),
  --     starter.gen_hook.padding(3, 2),
  --   },
  --   query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_-.",
  -- })
  --
  --   require("mini.surround").setup({
  --     mappings = {
  --       add = "ys", -- Add surrounding in Normal and Visual modes
  --       delete = "ds", -- Delete surrounding
  --       find = "gzf", -- Find surrounding (to the right)
  --       find_left = "gzF", -- Find surrounding (to the left)
  --       highlight = "gzh", -- Highlight surroundwng
  --       replace = "cs", -- Replace surroundwng
  --       update_n_lines = "gzn", -- Update `n_lines`
  --     },
  --   })
end

function mini.init()
  -- vim.api.nvim_create_user_command("NewSession", function(opts)
  --   MiniSessions.write(opts.args)
  -- end, { nargs = 1 })
  --:lua require('mini.colors').interactive():lua require('mini.colors').interactive()
  -- vim.api.nvim_create_user_command("DeleteSession", function()
  --   MiniSessions.select("delete")
  -- end, { nargs = 0 })
end

return specs
