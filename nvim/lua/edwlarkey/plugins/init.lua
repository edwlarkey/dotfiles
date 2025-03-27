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
          strings = false,
          comments = true,
          operators = false,
          folds = true,
          emphasis = true,
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
          ["@lsp.type.namespace.python"] = { link = "GruvboxOrange" },
          ["SnacksPickerDir"] = { link = "GruvboxPurple" },
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
  { "b0o/schemastore.nvim" },
  {
    "ibhagwan/fzf-lua",
    cond = not vim.g.vscode,
    opts = {
      lsp = {
        -- make lsp requests synchronous so they work with null-ls
        async_or_timeout = 3000,
      },
      git = {
        branches = {
          cmd_add = { "git", "switch", "-c" },
        },
      },
    },
    config = function()
      -- vim.keymap.set("n", ":<C-p>", function()
      --   require("fzf-lua").command_history()
      -- end, { desc = "FZF Command History" })
      -- vim.keymap.set("n", "<leader>ff", function()
      --   require("fzf-lua").git_files()
      -- end, { desc = "FZF Git Files" })
      -- -- vim.keymap.set("n", "<leader>fbr", function()
      -- --   require("fzf-lua").git_branches()
      -- -- end, { desc = "FZF Git Branches" })
      -- vim.keymap.set("n", "<leader>fb", function()
      --   require("fzf-lua").buffers()
      -- end, { desc = "FZF Buffers" })
      vim.keymap.set("n", "<leader>fm", function()
        require("fzf-lua").builtin()
      end, { desc = "FZF Menu" })
      -- vim.keymap.set("n", "<leader>fr", function()
      --   require("fzf-lua").live_grep()
      -- end, { desc = "FZF RipGrep" })
      -- vim.keymap.set("n", "<leader>fo", function()
      --   require("fzf-lua").oldfiles()
      -- end, { desc = "FZF oldfiles" })
      -- vim.keymap.set("n", "<leader>fa", function()
      --   require("fzf-lua").live_grep_resume()
      -- end, { desc = "FZF RipGrep Same Again" })
      -- vim.keymap.set("n", "<leader>d", function()
      --   require("fzf-lua").files()
      -- end, { desc = "FZF Files" })
      -- vim.keymap.set("n", "<leader>k", function()
      --   require("fzf-lua").files({ cwd = "~/txt", cmd = "fd --type f --exclude .stversions" })
      -- end, { desc = "FZF Wiki" })
      -- vim.keymap.set("n", "<leader>v", function()
      --   require("fzf-lua").files({ cwd = "~/dotfiles/nvim", cmd = "fd --type f" })
      -- end, { desc = "FZF Neovim Config" })
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      -- explorer = { enabled = true },
      -- indent = { enabled = true },
      -- input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      -- quickfile = { enabled = true },
      -- scope = { enabled = true },
      -- scroll = { enabled = true },
      statuscolumn = {
        enabled = true,
      },
      -- words = { enabled = true },
    },
    -- stylua: ignore
    keys = {
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ft", function() Snacks.picker.files({ cwd = "~/git/robin/sysops/iac/terraform" }) end, desc = "Terraform Project" },
      { "<leader>d", function() Snacks.picker.files({hidden = true}) end, desc = "Find Files" },
      { "<leader>ff", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      -- LSP
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = true,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },
  {
    "echasnovski/mini.nvim",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local gen_loader = require("mini.snippets").gen_loader

      require("mini.cursorword").setup({ delay = 500 })
      -- require("mini.statusline").setup()
      require("mini.bracketed").setup()
      require("mini.colors").setup()
      require("mini.icons").setup()
      -- require("mini.notify").setup()
      require("mini.snippets").setup({
        snippets = {
          -- gen_loader.from_file("~/.config/nvim/snippets/global.json"),

          -- Load snippets based on current language by reading files from
          -- "snippets/" subdirectories from 'runtimepath' directories.
          gen_loader.from_lang(),
        },
      })
      require("mini.comment").setup()
      require("mini.indentscope").setup({
        draw = {
          delay = 200,
          animation = require("mini.indentscope").gen_animation.none(),
        },
      })
      -- Surround
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
          { mode = "n", keys = "<Leader>f", desc = "+FZF" },
        },
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    cond = not vim.g.vscode,
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
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}, cond = not vim.g.vscode },
  {
    "petertriho/nvim-scrollbar",
    cond = not vim.g.vscode,
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
  { "tpope/vim-fugitive" },
  { "mbbill/undotree" },
  { "edwlarkey/vim-toggler" },
  -- Markdown & Wiki & Tex
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      vim.cmd([[
         filetype plugin indent on
         let g:vimtex_view_method = 'zathura'
         ]])
    end,
  },
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
  -- {
  --   "L3MON4D3/LuaSnip",
  --   dependencies = {
  --     "rafamadriz/friendly-snippets",
  --     config = function()
  --       require("luasnip.loaders.from_vscode").lazy_load()
  --     end,
  --   },
  --   opts = {
  --     history = true,
  --     delete_check_events = "TextChanged",
  --   },
  --   -- stylua: ignore
  --   keys = {
  --     {
  --       "<tab>",
  --       function()
  --         return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
  --       end,
  --       expr = true,
  --       silent = true,
  --       mode = "i",
  --     },
  --     { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
  --     { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
  --   },
  -- },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   event = { "InsertEnter", "CmdlineEnter" },
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp-signature-help",
  --     "hrsh7th/cmp-nvim-lsp-document-symbol",
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-buffer",
  --     "hrsh7th/cmp-cmdline",
  --     "hrsh7th/cmp-path",
  --     "L3MON4D3/LuaSnip",
  --     "saadparwaiz1/cmp_luasnip",
  --   },
  --   config = function(opts)
  --     vim.o.completeopt = "menuone,noselect"
  --
  --     local cmp = require("cmp")
  --
  --     cmp.setup({
  --       completion = {
  --         completeopt = "menu,menuone,noinsert",
  --       },
  --       snippet = {
  --         expand = function(args)
  --           require("luasnip").lsp_expand(args.body)
  --         end,
  --       },
  --       mapping = require("edwlarkey.keymaps").cmp.insert(),
  --       sources = cmp.config.sources({
  --         { name = "nvim_lsp" },
  --         { name = "nvim_lsp_signature_help" },
  --         { name = "luasnip" },
  --         { name = "mkdnflow" },
  --         { name = "buffer" },
  --         { name = "path" },
  --       }),
  --     })
  --     cmp.setup.cmdline(":", {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = cmp.config.sources({
  --         { name = "path" },
  --         { name = "cmdline" },
  --       }),
  --     })
  --     cmp.setup.cmdline({ "/", "?" }, {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = cmp.config.sources({
  --         { name = "nvim_lsp_document_symbol" },
  --       }, {
  --         { name = "buffer" },
  --       }),
  --     })
  --   end,
  -- },
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = {
      "giuxtaposition/blink-cmp-copilot",
    },

    -- use a release tag to download pre-built binaries
    version = "v0.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = {
        preset = "super-tab",
        ["<C-y>"] = { "select_and_accept" },
      },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
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

      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, via `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },

      -- experimental signature help support
      signature = { enabled = true },
    },
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    config = true,
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Select Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "fredrikaverpil/neotest-golang",
        version = "*",
        dependencies = {
          "leoluz/nvim-dap-go",
        },
      },
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      opts.adapters["neotest-golang"] = {
        go_test_args = {
          "-v",
          -- "-race",
          "-coverprofile="
            .. vim.fn.getcwd()
            .. "/coverage.out",
        },
      }
    end,
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-golang"),
        },
      })
    end,
    keys = {
      {
        "<leader>ta",
        function()
          require("neotest").run.attach()
        end,
        desc = "[t]est [a]ttach",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "[t]est run [f]ile",
      },
      {
        "<leader>tA",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "[t]est [A]ll files",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.run({ suite = true })
        end,
        desc = "[t]est [S]uite",
      },
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "[t]est [n]earest",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "[t]est [l]ast",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "[t]est [s]ummary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "[t]est [o]utput",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "[t]est [O]utput panel",
      },
      {
        "<leader>tt",
        function()
          require("neotest").run.stop()
        end,
        desc = "[t]est [t]erminate",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ suite = false, strategy = "dap" })
        end,
        desc = "Debug nearest test",
      },
      {
        "<leader>tD",
        function()
          require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
        end,
        desc = "Debug current file",
      },
    },
  },
}
