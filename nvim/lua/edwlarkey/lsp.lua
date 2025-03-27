vim.lsp.enable({
  "gopls",
  "luals",
  "golangci-lint-langserver",
  "yaml-language-server",
  "basedpyright",
  "ruff",
  "terraform_ls",
  "dockerls",
  "jsonls",
})

vim.diagnostic.config({
  virtual_lines = { current_line = true },
})

local Util = require("edwlarkey.util")
-- setup keymaps
Util.on_attach(function(client, buffer)
  require("edwlarkey.keymaps").setup.lsp(buffer)
end)
