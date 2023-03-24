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
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "mbbill/undotree" },
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.g.tmux_navigator_no_mappings = true
    end,
  },
  { "edwlarkey/vim-toggler" },
  { "zhimsel/vim-stay", lazy = false },
  -- Markdown & Wiki
  { "edwlarkey/vim-textcal", ft = "textcal" },
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
  { url = "git@git.sr.ht:~edwlarkey/markdown-index.nvim", ft = "markdown" },
  { "lervag/vimtex", ft = "tex" },
}
