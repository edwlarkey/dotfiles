return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
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
}
