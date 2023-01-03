return {
  { "nvim-lua/plenary.nvim" },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  -- { "fatih/vim-go", ft = "go" },
  { "williamboman/mason-lspconfig.nvim" },
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
    config = {
      wrap = true,
      links = {
        conceal = true,
      },
    },
  },
  { url = "git@git.sr.ht:~edwlarkey/markdown-index.nvim", ft = "markdown" },
  { "lervag/vimtex", ft = "tex" },
}
