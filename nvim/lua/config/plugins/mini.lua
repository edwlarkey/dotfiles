local mini = {
  "echasnovski/mini.nvim",
}

local specs = { mini, "JoosepAlviste/nvim-ts-context-commentstring" }

function mini.surround()
  require("mini.surround").setup({
    mappings = {
      add = "gza", -- Add surrounding in Normal and Visual modes
      delete = "gzd", -- Delete surrounding
      find = "gzf", -- Find surrounding (to the right)
      find_left = "gzF", -- Find surrounding (to the left)
      highlight = "gzh", -- Highlight surrounding
      replace = "gzr", -- Replace surrounding
      update_n_lines = "gzn", -- Update `n_lines`
    },
  })
end

function mini.cursorword()
  require('mini.cursorword').setup({delay = 500,})
end
function mini.sessions()
  require('mini.sessions').setup()
end

function mini.jump()
  require("mini.jump").setup({})
end

function mini.pairs()
  require("mini.pairs").setup({})
end

function mini.comment()
  require("mini.comment").setup({
    hooks = {
      pre = function()
        require("ts_context_commentstring.internal").update_commentstring({})
      end,
    },
  })
end

function mini.starter()
  local starter = require('mini.starter')
  starter.setup({
    evaluate_single = false,
    items = {
      starter.sections.builtin_actions(),
      starter.sections.recent_files(5, false),
      starter.sections.recent_files(5, true),
      -- Use this if you set up 'mini.sessions'
      starter.sections.sessions(5, true)
    },
    content_hooks = {
      starter.gen_hook.adding_bullet(),
      -- starter.gen_hook.indexing('all', { 'Builtin actions' }),
      starter.gen_hook.padding(3, 2),
    },
    query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',
  })
end

function mini.config()
  mini.cursorword()
  mini.sessions()
  mini.comment()
  mini.surround()
  mini.starter()
end

function mini.init()
  vim.api.nvim_create_user_command(
    'NewSession',
    function(opts)
      MiniSessions.write(opts.args)
    end,
    { nargs = 1 }
  )

  vim.api.nvim_create_user_command(
    'DeleteSession',
    function()
      MiniSessions.select("delete")
    end,
    { nargs = 0 }
  )
end

return specs
