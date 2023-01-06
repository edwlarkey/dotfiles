local M = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    "jose-elias-alvarez/null-ls.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
}

function M.config()
  require("mason")
  require("config.plugins.lsp.diagnostics").setup()

  local function on_attach(client, bufnr)
    -- require("nvim-navic").attach(client, bufnr)
    require("config.plugins.lsp.formatting").setup(client, bufnr)
    require("config.keymaps").setup.lsp(bufnr)
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
    gopls = {},
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
              enabled = true,
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
    pyright = {},
    yamlls = {},
    sumneko_lua = {
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
    -- tailwindcss = {},
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

  require("config.plugins.null-ls").setup(options)
end

return M
