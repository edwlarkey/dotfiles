return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("gruvbox").setup({
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = true,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "soft",
        palette_overrides = {},
        overrides = {
          ["@lsp.type.parameter"] = { link = "GruvboxOrange" },
        },
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.cmd([[colorscheme gruvbox]])
    end,
  },
  {
    "Verf/deepwhite.nvim",
    branch = "main",
    lazy = false,
    priority = 1000,
    config = function()
      require("deepwhite").setup({
        low_blue_light = true,
      })
      -- vim.cmd([[colorscheme deepwhite]])
    end,
  },
  { "nvim-lua/plenary.nvim" },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      lsp = {
        -- make lsp requests synchronous so they work with null-ls
        async_or_timeout = 3000,
      },
    },
  },
  {
    "echasnovski/mini.nvim",
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("mini.cursorword").setup({ delay = 500 })
      require("mini.statusline").setup()
      require("mini.bracketed").setup()
      require("mini.colors").setup()
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
      require("mini.comment").setup({
        hooks = {
          pre = function()
            require("ts_context_commentstring.internal").update_commentstring({})
          end,
        },
      })
      require("mini.hipatterns").setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
        },
      })
      -- require("mini.sessions").setup()
      -- require("mini.jump").setup({})
      -- require("mini.pairs").setup({})
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
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
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
          { mode = "n", keys = "<Leader>f", desc = "+FZF" },
        },
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = {
            text = "│",
          },
          change = {
            text = "│",
          },
          delete = {
            text = "_",
          },
          topdelete = {
            text = "‾",
          },
          changedelete = {
            text = "~",
          },
        },
        current_line_blame_opts = {
          delay = 150,
        },
        on_attach = function(buffer)
          require("edwlarkey.keymaps").setup.gitsigns(buffer)
        end,
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
    -- event = "BufReadPre",
    opts = {
      show_current_context = true,
      show_current_context_start = true,
      show_trailing_blankline_indent = false,
      use_treesitter = true,
      filetype_exclude = {
        "help",
      },
    },
  },
  {
    "folke/which-key.nvim",
    enabled = false,
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        layout = {
          height = { min = 3, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3, -- spacing between columns
          align = "center", -- align columns left, center or right
        },
        triggers_blacklist = { -- list of mode / prefixes that should never be hooked by WhichKey
          i = { "g" },
        },
      })

      require("edwlarkey.keymaps").whichkey.register()
    end,
  },
  {
    "stevearc/overseer.nvim",
    dependencies = { "ibhagwan/fzf-lua", "stevearc/dressing.nvim" },
    opts = {
      component_aliases = {
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_notify",
          "on_complete_dispose",
        },
      },
    },
  },
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
  -- { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "mbbill/undotree" },
  { "edwlarkey/vim-toggler" },
  -- Markdown & Wiki & Tex
  { "lervag/vimtex", ft = "tex" },
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
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.g.tmux_navigator_no_mappings = true
    end,
  },
  -- Alternate between files, such as foo.go and foo_test.go
  {
    "rgroli/other.nvim",
    keys = {
      { ":A", "<cmd>Other<cr>", { noremap = true, silent = true } },
      { ":AV", "<cmd>OtherVSplit<cr>", { noremap = true, silent = true } },
      { ":AS", "<cmd>OtherSplit<cr>", { noremap = true, silent = true } },
    },
    config = function()
      require("other-nvim").setup({
        mappings = {
          "rails", --builtin mapping
          {
            pattern = "(.*).go$",
            target = "%1_test.go",
            context = "test",
          },
          {
            pattern = "(.*)_test.go$",
            target = "%1.go",
            context = "file",
          },
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function(opts)
      vim.o.completeopt = "menuone,noselect"
      vim.g.vsnip_snippet_dir = "~/.config/nvim/snippets"

      local cmp = require("cmp")

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = require("edwlarkey.keymaps").cmp.insert(),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
      cmp.setup.filetype("norg", {
        sources = cmp.config.sources({
          { name = "path" },
          { name = "neorg" },
          { name = "buffer" },
        }),
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "nvim_lsp_document_symbol" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
