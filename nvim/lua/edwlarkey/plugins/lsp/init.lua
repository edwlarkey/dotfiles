local M = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    "jose-elias-alvarez/null-ls.nvim",
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    "folke/neodev.nvim",
  },
}

function M.mason_check(tools)
  local mr = require("mason-registry")
  for _, tool in ipairs(tools) do
    local p = mr.get_package(tool)
    if not p:is_installed() then
      p:install()
    end
  end
end

function M.config()
  require("neodev").setup()
  require("edwlarkey.plugins.lsp.diagnostics").setup()

  local function on_attach(client, bufnr)
    -- require("nvim-navic").attach(client, bufnr)
    require("edwlarkey.plugins.lsp.formatting").setup(client, bufnr)
    require("edwlarkey.keymaps").setup.lsp(bufnr)
    if client.server_capabilities["codeLensProvider"] then
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("codelens", { clear = false }),
        buffer = bufnr,
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

    -- vim.api.nvim_create_autocmd("CursorHold", {
    --   buffer = bufnr,
    --   callback = function()
    --     local opts = {
    --       focusable = false,
    --       close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    --       border = "rounded",
    --       source = "always",
    --       prefix = " ",
    --       scope = "cursor",
    --     }
    --     vim.diagnostic.open_float(nil, opts)
    --   end,
    -- })
  end

  local null_ls = require("null-ls")
  -- local h = require("null-ls.helpers")
  null_ls.setup({
    debug = true,
    sources = {
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
    on_attach = on_attach,
    root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git"),
  })

  local tools = {
    "stylua",
    "shellcheck",
    "black",
    "isort",
    "ruff",
  }

  local servers = {
    bashls = {},
    cssls = {},
    dockerls = {},
    html = {},
    jsonls = {
      on_new_config = function(new_config)
        new_config.settings.json.schemas = new_config.settings.json.schemas or {}
        vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
      end,
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
    gopls = {
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
    pylsp = {
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
    ruff_lsp = {},
    -- pyright = {
    --     python = {
    --       analysis = {
    --         typeCheckingMode = "off",
    --         autoSearchPaths = true,
    --         useLibraryCodeForTypes = true,
    --         diagnosticMode = "workspace",
    --       },
    --     },
    -- },
    yamlls = {
      on_new_config = function(new_config)
        new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
        vim.list_extend(new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
      end,
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
    lua_ls = {
      single_file_support = true,
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
  }

  M.mason_check(tools)
  require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = true,
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  require("mason-lspconfig").setup_handlers({
    function(server_name)
      require("lspconfig")[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
        flags = {
          debounce_text_changes = 150,
        },
      })
    end,
  })

  --
  -- To use this method of configuring the lsp servers instead of mason-lspconfig
  -- add a settings key to the servers tables like this:
  --
  --
  -- gopls = {
  --   settings = { -- Add this
  --     gopls = {
  --       semanticTokens = true,
  --       etc
  --       ...
  --     },
  --   },
  -- },
  --
  -- instead of no settings key like:
  --
  --
  -- gopls = {
  --   gopls = {
  --     semanticTokens = true,
  --     etc
  --     ...
  --   },
  -- },
  --
  --
  -- local options = {
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  --   flags = {
  --     debounce_text_changes = 150,
  --   },
  -- }
  --
  -- for server, opts in pairs(servers) do
  --   opts = vim.tbl_deep_extend("force", {}, options, opts or {})
  --   require("lspconfig")[server].setup(opts)
  -- end
end

return M
