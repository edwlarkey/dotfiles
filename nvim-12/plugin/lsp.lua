vim.diagnostic.config({
  virtual_lines = { current_line = true },
})

vim.lsp.inline_completion.enable(true)

-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = au,
--   desc = "LSP notify",
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client then
--       Snacks.notify(("attached to buffer %i"):format(args.buf), {
--         level = vim.log.levels.DEBUG,
--         title = "LSP: " .. client.name,
--       })
--     end
--   end,
-- })

vim.lsp.enable({
  "gopls",
  "lua_ls",
  "golangci-lint-langserver",
  "arduino_language_server",
  -- "copilot",
  "yamlls",
  "basedpyright",
  "ruff",
  "terraformls",
  "dockerls",
  "jsonls",
  "gh_actions_ls",
})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      semanticTokens = true,
      experimentalPostfixCompletions = true,
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      -- analyses = {
      --   unusedparams = false,
      --   shadow = false,
      --   nilness = true,
      -- },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
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
      hints = {
        rangeVariableTypes = true,
        parameterNames = true,
        constantValues = true,
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        functionTypeParameters = true,
      },
    },
  },
})

vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "off", -- off, basic, standard, strict, all
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        autoImportCompletions = true,
        diagnosticsMode = "openFilesOnly", -- workspace, openFilesOnly
        diagnosticSeverityOverrides = {
          reportUnknownMemberType = false,
          reportUnknownArgumentType = false,
          -- reportUnusedClass = "warning",
          -- reportUnusedFunction = "warning",
          reportUndefinedVariable = false, -- ruff handles this with F822
        },
      },
    },
  },
})

vim.lsp.config("jsonls", {
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
})

vim.lsp.config("lua_ls", {
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
      hint = {
        enable = true,
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
})

vim.lsp.config("yamlls", {
  settings = {
    orderkeys = false,
    redhat = { telemetry = { enabled = false } },
    yaml = {
      format = true,
      schemas = {
        require("schemastore").yaml.schemas(),
      },
    },
  },
})
