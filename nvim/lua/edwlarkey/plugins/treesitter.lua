return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",

  dependencies = {
    "nvim-treesitter/nvim-treesitter-refactor",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "mfussenegger/nvim-treehopper",
    "windwp/nvim-ts-autotag",
    -- {
    --   "nvim-treesitter/playground",
    --   cmd = "TSPlaygroundToggle",
    -- },
  },

  opts = {
    ensure_installed = {
      -- Required
      "c",
      "lua",
      "vim",
      "vimdoc",
      "query",
      -- Extra languages
      "bash",
      "go",
      "html",
      "json",
      "python",
      "yaml",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-n>",
        node_incremental = "<C-n>",
        scope_incremental = "<C-s>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["aa"] = { query = "@parameter.outer", desc = "around parameter" },
          ["ia"] = { query = "@parameter.inner", desc = "inside parameter" },
          ["af"] = { query = "@function.outer", desc = "around function" },
          ["if"] = { query = "@function.inner", desc = "inside function" },
          ["ac"] = { query = "@class.outer", desc = "around class" },
          ["ic"] = { query = "@class.inner", desc = "inside clas" },
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
    playground = {
      enable = true,
    },
    autotag = {
      enable = true,
      enable_rename = true,
      enable_close = true,
      enable_close_on_slash = true,
      filetypes = { "html", "xml", "gotmpl" },
    },
    refactor = {
      smart_rename = {
        enable = true,
        client = {
          smart_rename = "grr",
        },
      },
    },
  },

  config = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      ---@type table<string, boolean>
      local added = {}
      opts.ensure_installed = vim.tbl_filter(function(lang)
        if added[lang] then
          return false
        end
        added[lang] = true
        return true
      end, opts.ensure_installed)
    end
    require("nvim-treesitter.configs").setup(opts)

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.gotmpl = {
      install_info = {
        -- url = "https://github.com/ngalaiko/tree-sitter-go-template",
        url = "https://github.com/dannylongeuay/tree-sitter-go-template",
        files = { "src/parser.c" },
      },
      filetype = "gotmpl",
      used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "tmpl" },
    }
  end,
}
