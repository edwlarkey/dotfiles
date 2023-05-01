return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      icons = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      },
      -- options for vim.diagnostic.config()
      diagnostics = {
        virtual_text = false,
        virtual_lines = true,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      },
      -- add any global capabilities here
      capabilities = {},
      -- Automatically format on save
      autoformat = true,
      -- LSP Server Settings
      servers = {
        bashls = {},
        cssls = {},
        dockerls = {},
        html = {},
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
              schemas = {
                {
                  description = "Robin-deploy json config files",
                  fileMatch = { "services/*/*.json" },
                  url = "/Users/edwardlarkey/git/robin/sysops/robin-deploy/services/data.schema.json",
                },
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              semanticTokens = true,
              experimentalPostfixCompletions = true,
              analyses = {
                unusedparams = false,
                shadow = false,
                nilness = true,
              },
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              staticcheck = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = {
                  ignore = { "E501", "W503" },
                  maxLineLength = 100,
                  enabled = false,
                },
                pyflakes = {
                  enabled = false,
                },
              },
              jedi_completion = {
                enabled = true,
                eager = true,
                cache_for = { "aws_cdk" },
                include_function_objects = true,
                include_class_objects = true,
                include_params = true,
              },
            },
          },
        },
        ruff_lsp = {},
        -- pyright = {
        -- settings = {
        --     python = {
        --       analysis = {
        --         typeCheckingMode = "off",
        --         autoSearchPaths = true,
        --         useLibraryCodeForTypes = true,
        --         diagnosticMode = "workspace",
        --       },
        --     },
        -- },
        -- },
        yamlls = {
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
            vim.list_extend(new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
          end,
          settings = {
            yaml = {
              orderedKeys = false,
              -- format = {
              --   enable = true,
              -- },
              -- schemas = {
              --   ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              -- },
            },
          },
        },
        lua_ls = {
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- path = runtime_path,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {
                  "--log-level=trace",
                },
              },
              diagnostics = {
                globals = { "vim" },
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      require("lsp_lines").setup()
      -- setup autoformat
      require("edwlarkey.plugins.lsp.formatting").autoformat = opts.autoformat
      -- setup formatting and keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("edwlarkey.plugins.lsp.formatting").setup(client, buffer)
          require("edwlarkey.keymaps").setup.lsp(buffer)
          if client.server_capabilities["codeLensProvider"] then
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              group = vim.api.nvim_create_augroup("codelens", { clear = false }),
              buffer = buffer,
              callback = function()
                pcall(vim.lsp.codelens.refresh)
              end,
            })
          end
          if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
              range = true,
            }
          end
        end,
      })

      -- diagnostics
      for name, icon in pairs(opts.icons) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      local servers = opts.servers
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities(),
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available thourgh mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        mlsp.setup({ ensure_installed = ensure_installed })
        mlsp.setup_handlers({ setup })
      end
    end,
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local null_ls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          -- nls.builtins.diagnostics.flake8,
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.code_actions.gomodifytags,
          -- null_ls.builtins.code_actions.cspell.with({
          --   extra_args = { "--config", "~/dotfiles/cspell.json" },
          -- }),
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.gofmt,
          -- null_ls.builtins.diagnostics.cspell.with({
          --   diagnostics_postprocess = function(diagnostic)
          --     diagnostic.severity = vim.diagnostic.severity.HINT
          --   end,
          --   extra_args = { "--config", "~/dotfiles/cspell.json" },
          -- }),
          null_ls.builtins.formatting.prettier.with({
            extra_filetypes = { "toml" },
            extra_args = { "--no-semi" },
          }),
          null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
          null_ls.builtins.formatting.ruff,
          null_ls.builtins.formatting.stylua.with({
            extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          }),
        },
      }
    end,
  },

  -- cmdline tools
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "black",
        "isort",
        "ruff",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
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
    end,
  },
}
