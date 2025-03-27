local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

return {
  capabilities = capabilities,
  cmd = { "gopls" },
  root_markers = { "go.mod" },
  filetypes = { "go", "gomod" },
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
}
