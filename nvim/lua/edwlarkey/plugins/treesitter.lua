local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",

  dependencies = {
    "nvim-treesitter/nvim-treesitter-refactor",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "mfussenegger/nvim-treehopper",
    "HiPhish/nvim-ts-rainbow2",
  },
}

function M.init()
  vim.cmd([[
    omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
    xnoremap <silent> m :lua require('tsht').nodes()<CR>
  ]])
end

function M.config()
  local rainbow = require("ts-rainbow")
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
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
    rainbow = {
      enable = true,
      query = {
        "rainbow-parens",
        html = "rainbow-tags",
      },
      strategy = {
        rainbow.strategy.global,
      },
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
