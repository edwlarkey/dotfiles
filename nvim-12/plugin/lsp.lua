vim.diagnostic.config({
  virtual_lines = { current_line = true },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = au,
  desc = "LSP notify",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      Snacks.notify(("attached to buffer %i"):format(args.buf), {
        level = vim.log.levels.DEBUG,
        title = "LSP: " .. client.name,
      })
    end
  end,
})

vim.lsp.enable({
  "gopls",
  "luals",
  "golangci-lint-langserver",
  "yaml-language-server",
  "basedpyright",
  "ruff",
  "terraform-ls",
  "dockerls",
  "jsonls",
})
