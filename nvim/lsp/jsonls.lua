
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true,
  },
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
  single_file_support = true,
}
