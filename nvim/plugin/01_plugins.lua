vim.g.mapleader = " "
vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
  { src = "https://github.com/Verf/deepwhite.nvim" },
  { src = "https://github.com/folke/snacks.nvim", lazy = false },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/nvim-mini/mini.nvim" },
  { src = "https://github.com/b0o/schemastore.nvim" },
  { src = "https://github.com/folke/ts-comments.nvim" },
  { src = "https://github.com/ethanholz/nvim-lastplace" },
  { src = "https://github.com/christoomey/vim-tmux-navigator" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/mfussenegger/nvim-lint" },
  -- { src = "https://github.com/zbirenbaum/copilot.lua" },
  { src = "https://github.com/fang2hou/blink-copilot" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
  { src = "https://github.com/folke/sidekick.nvim" },
  { src = "https://github.com/chomosuke/typst-preview.nvim" },
}, { load = true })

vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
vim.g.tmux_navigator_no_mappings = true

require("deepwhite").setup({ low_blue_light = true })
require("gruvbox").setup({
  italic = { strings = false },
  contrast = "soft",
  overrides = {
    ["@lsp.type.parameter"] = { link = "GruvboxOrange" },
    ["@lsp.type.namespace.python"] = { link = "GruvboxOrange" },
    ["SnacksPickerDir"] = { link = "GruvboxPurple" },
  },
})
vim.cmd([[colorscheme gruvbox]])

require("nvim-treesitter").setup()
require("ts-comments").setup()
require("nvim-lastplace").setup({
  lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
  lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
})

require("conform").setup({
  notify_on_error = false,
  default_format_opts = { lsp_format = "fallback" },
  formatters_by_ft = {
    lua = { "stylua" },
    python = {
      -- To fix lint errors.
      "ruff_fix",
      -- To run the Ruff formatter.
      "ruff_format",
    },
    markdown = { "prettierd", "prettier" },
    yaml = { "prettierd", "prettier" },
    gha = { "prettierd", "prettier" },
    terraform = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },
  },
  formatters = {
    shfmt = {
      prepend_args = { "-i", "2", "-ci" },
    },
    stylua = {
      prepend_args = { "--indent-type", "Spaces", "--indent-width", "2", "--column-width", "120" },
    },
  },
  format_on_save = function(bufnr)
    -- Disable autoformat on certain filetypes
    local ignore_filetypes = { "sql" }
    if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
      return
    end
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 1000, lsp_format = "fallback" }
  end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

-- Linting
local lint = require("lint")
lint.linters_by_ft = {
  lua = { "luacheck" },
  python = { "ruff" },
  sh = { "shellcheck" },
  yaml = { "yamllint" },
  go = { "golangcilint" },
  gha = { "actionlint" },
}
-- for k, v in pairs(opts.linters) do
--   lint.linters[k] = v
-- end

local yl = lint.linters.yamllint
table.insert(yl.args, 1, function()
  local conf = vim.fs.find(".yamllint", {
    upward = true,
    stop = vim.fs.dirname(vim.uv.os_homedir()),
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
  })
  if #conf > 0 then
    return string.format("--config-file=%s", conf[1])
  end
end)

local timer = assert(vim.loop.new_timer())
local DEBOUNCE_MS = 500
local aug = vim.api.nvim_create_augroup("Lint", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = aug,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    timer:stop()
    timer:start(
      DEBOUNCE_MS,
      0,
      vim.schedule_wrap(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.api.nvim_buf_call(bufnr, function()
            lint.try_lint(nil, { ignore_errors = true })
          end)
        end
      end)
    )
  end,
})
lint.try_lint(nil, { ignore_errors = true })

-- End Linting

-- require("copilot").setup({
--   suggestion = {
--     enabled = false,
--     auto_trigger = true,
--     keymap = {
--       accept = false, -- handled by nvim-cmp / blink.cmp
--       next = "<M-]>",
--       prev = "<M-[>",
--     },
--   },
--   panel = { enabled = false },
--   filetypes = {
--     markdown = true,
--     help = true,
--   },
-- })

require("blink.cmp").setup({
  fuzzy = { implementation = "prefer_rust_with_warning" },
  signature = { enabled = true },
  keymap = {
    preset = "super-tab",
    ["<C-y>"] = { "select_and_accept" },
  },

  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
  },

  completion = {
    menu = {
      draw = {
        treesitter = { "lsp" },
        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind", "source_name" } },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
  },

  snippets = { preset = "mini_snippets" },

  sources = {
    -- default = { "lsp", "path", "snippets", "buffer", "copilot" },
    default = { "lsp", "path", "snippets", "buffer" },
    -- providers = {
    --   copilot = {
    --     name = "copilot",
    --     module = "blink-copilot",
    --     score_offset = 100,
    --     async = true,
    --   },
    -- },
  },
})

require("sidekick").setup({
  opts = {
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
    },
    tools = {
      gemini = {
        cmd = { "gemini" },
        env = {
          GOOGLE_CLOUD_PROJECT = "robin-tooling",
        },
      },
    },
  },
})

-- stylua: ignore start
-- Goto/Apply Next Edit Suggestion
vim.keymap.set('n', '<tab>', function()
  -- if there is a next edit, jump to it, otherwise apply it if any
  if not require("sidekick").nes_jump_or_apply() then
    return "<Tab>" -- fallback to normal tab
  end
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })
-- Sidekick Toggle
vim.keymap.set({ "n", "t", "i", "x" }, '<c-.>', function() require("sidekick.cli").toggle() end, { desc = "Sidekick Toggle" })
-- Sidekick Toggle CLI
vim.keymap.set('n', '<leader>aa', function() require("sidekick.cli").toggle() end, { desc = "Sidekick Toggle CLI" })
-- Select CLI
vim.keymap.set('n', '<leader>as', function() require("sidekick.cli").select() end, { desc = "Select CLI" })
-- Send This
vim.keymap.set({ "x", "n" }, '<leader>at', function() require("sidekick.cli").send({ msg = "{this}" }) end, { desc = "Send This" })
-- Send File
vim.keymap.set('n', '<leader>af', function() require("sidekick.cli").send({ msg = "{file}" }) end, { desc = "Send File" })
-- Send Visual Selection
vim.keymap.set('x', '<leader>av', function() require("sidekick.cli").send({ msg = "{selection}" }) end, { desc = "Send Visual Selection" })
-- Sidekick Select Prompt
vim.keymap.set({ "n", "x" }, '<leader>ap', function() require("sidekick.cli").prompt() end, { desc = "Sidekick Select Prompt" })
-- Sidekick Toggle Gemini
vim.keymap.set('n', '<leader>ac', function() require("sidekick.cli").toggle({ name = "gemini", focus = true }) end, { desc = "Sidekick Toggle Gemini" })
-- stylua: ignore end

require("mason").setup()
local mr = require("mason-registry")
local install_lsps = {
  "stylua",
  "shellcheck",
  "gopls",
  "ruff",
}
local function ensure_installed()
  for _, tool in ipairs(install_lsps) do
    local p = mr.get_package(tool)
    if not p:is_installed() then
      p:install()
    end
  end
end
if mr.refresh then
  mr.refresh(ensure_installed)
else
  ensure_installed()
end

require("snacks").setup({
  bigfile = { enabled = true },
  dashboard = {
    enabled = false,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
    },
  },
  -- explorer = { enabled = true },
  indent = { enabled = true },
  -- input = { enabled = true },
  picker = { enabled = true },
  notifier = { enabled = true },
  -- scope = { enabled = true },
  -- scroll = { enabled = true },
  statuscolumn = {
    enabled = true,
  },
  -- words = { enabled = true },
})

require("mini.cursorword").setup({ delay = 500 })
require("mini.statusline").setup()
require("mini.bracketed").setup()
require("mini.colors").setup()
require("mini.icons").setup()
require("mini.diff").setup()
require("mini.comment").setup()
-- require("mini.notify").setup()
local gen_loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
  snippets = {
    gen_loader.from_lang(),
  },
})
require("mini.surround").setup({
  mappings = {
    add = "ys",
    delete = "ds",
    find = "",
    find_left = "",
    highlight = "",
    replace = "cs",
    update_n_lines = "",

    -- Add this only if you don't want to use extended mappings
    suffix_last = "",
    suffix_next = "",
  },
  search_method = "cover_or_next",
})
-- Remap adding surrounding to Visual mode selection
vim.keymap.del("x", "ys")
vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
-- Make special mapping for "add surrounding for line"
vim.keymap.set("n", "yss", "ys_", { remap = true })
-- End Surround

local hi_words = require("mini.extra").gen_highlighter.words
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
    -- names = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),

    -- Highlight hex color strings (`#rrggbb`) using that color #ab77ee
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})
local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },

    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    -- Marks
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

    -- Registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },

    -- mini.bracketed
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    { mode = "n", keys = "<Leader>l", desc = "+LSP" },
    { mode = "n", keys = "<Leader>f", desc = "+Picker" },
  },
})
