return {
  { "nvim-lua/plenary.nvim" },
  -- {
  --   "rcarriga/nvim-notify",
  --   config = function()
  --     vim.notify = require("notify")
  --   end,
  -- },
  {
    "stevearc/resession.nvim",
    opts = {
      extensions = {
        overseer = {},
      },
    },
  },
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    config = function()
      require("scrollbar").setup()
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
  {
    "ethanholz/nvim-lastplace",
    opts = {
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
    },
  },
  -- {
  --   "stevearc/aerial.nvim",
  --   cmd = "AerialToggle",
  --   config = function()
  --     -- symbol outline (also for treesitter/man/markdown)
  --     local aerial = require("aerial")
  --     aerial.setup({
  --       -- backends = { "lsp", "treesitter", "markdown", "man" },
  --       backends = { "treesitter", "lsp", "markdown", "man" },
  --       filter_kind = false,
  --       show_guides = true,
  --     })
  --   end,
  -- },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "mbbill/undotree" },
  {
    config = function()
      vim.g.tmux_navigator_no_mappings = true
    end,
    "christoomey/vim-tmux-navigator",
  },
  { "edwlarkey/vim-toggler" },
  -- Markdown & Wiki
  -- { "edwlarkey/vim-textcal", ft = "textcal" },
  { "plasticboy/vim-markdown" },
  {
    "jakewvincent/mkdnflow.nvim",
    ft = "markdown",
    opts = {
      wrap = true,
      links = {
        conceal = true,
      },
    },
  },
  -- { url = "git@git.sr.ht:~edwlarkey/markdown-index.nvim", ft = "markdown" },
  { "lervag/vimtex", ft = "tex" },
}
