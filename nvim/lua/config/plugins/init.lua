return {
  { "nvim-lua/plenary.nvim" },
  -- {"tpope/vim-commentary"},
  -- {"tpope/vim-surround"},
  { "tpope/vim-repeat" },
  { "plasticboy/vim-markdown" },
  { "fatih/vim-go" },
  -- LSP
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "jose-elias-alvarez/null-ls.nvim" },
  -- Syntax and Appearance
  { url = "git@git.sr.ht:~p00f/nvim-ts-rainbow" },
  { "edwlarkey/vim-textcal" },
  { "sainnhe/gruvbox-material" },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("gruvbox").setup({
        undercurl = true,
        underline = true,
        bold = false,
        italic = false,
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "soft",
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
      -- Setting this in appearance file to auto switch between light and dark
      -- vim.cmd([[colorscheme gruvbox]])
    end,
  },
  { "sainnhe/everforest" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "petertriho/nvim-scrollbar" },
  -- Markdown & Wiki
  { "jakewvincent/mkdnflow.nvim", config = true },
  { url = "git@git.sr.ht:~edwlarkey/markdown-index.nvim"},
  { "mbbill/undotree" },
  { "christoomey/vim-tmux-navigator" },
  { "edwlarkey/vim-toggler" },
  { "lervag/vimtex" },
  { "junegunn/vim-peekaboo" },
  { "zhimsel/vim-stay" },
}
