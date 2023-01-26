local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",

  dependencies = {
    "nvim-treesitter/nvim-treesitter-refactor",
    "mfussenegger/nvim-treehopper",
    "mrjones2014/nvim-ts-rainbow",
  },
}

function M.init()
  vim.cmd([[
    omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
    xnoremap <silent> m :lua require('tsht').nodes()<CR>
  ]])
end

function M.config()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "bash",
      "go",
      "html",
      "json",
      "lua",
      "python",
      "yaml",
      "vim",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-n>",
        node_incremental = "<C-n>",
        scope_incremental = "<C-s>",
        node_decremental = "<C-r>",
      },
    },
    rainbow = {
      enable = true,
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    },
    refactor = {
      smart_rename = {
        enable = true,
        client = {
          smart_rename = "grr",
        },
      },
    },
  })
  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  parser_config.gotmpl = {
    install_info = {
      url = "https://github.com/ngalaiko/tree-sitter-go-template",
      files = { "src/parser.c" },
    },
    filetype = "gotmpl",
    used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" },
  }
end

return M
