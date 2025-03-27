return {
  cmd = {
    "yaml-language-server",
    "--stdio",
  },
  filetypes = {
    "yaml",
  },
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
}
