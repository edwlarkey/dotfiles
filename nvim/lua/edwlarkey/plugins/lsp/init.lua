local M = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    "jose-elias-alvarez/null-ls.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    "folke/neodev.nvim",
  },
}

function M.config()
  require("mason")
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
    --
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
          experimentalPostfixCompletions = true,
          analyses = {
            unusedparams = false,
            shadow = false,
            nilness = true,
          },
          staticcheck = true,
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
    --   settings = {
    --     python = {
    --       analysis = {
    --         typeCheckingMode = "off",
    --         autoSearchPaths = true,
    --         useLibraryCodeForTypes = true,
    --         diagnosticMode = "workspace",
    --       },
    --     },
    --   },
    -- },
    yamlls = {
      settings = {
        yaml = {
          orderedKeys = false,
          -- format = {
          --   enable = true,
          -- },
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          },
        },
      },
    },
    lua_ls = {
      single_file_support = true,
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
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
  }

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  local options = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }

  for server, opts in pairs(servers) do
    opts = vim.tbl_deep_extend("force", {}, options, opts or {})
    require("lspconfig")[server].setup(opts)
  end

  require("edwlarkey.plugins.null-ls").setup(options)
end

return M
