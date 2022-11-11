require('mini.cursorword').setup({delay = 500,})
require('mini.sessions').setup()

vim.api.nvim_create_user_command(
    'NewSession',
    function(opts)
        MiniSessions.write(opts.args)
    end,
    { nargs = 1 }
)

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
-- require('mini.base16').setup()
