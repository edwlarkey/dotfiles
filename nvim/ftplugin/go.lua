vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = false
vim.opt_local.listchars = "tab:  "

local goaugroup = vim.api.nvim_create_augroup("goformat", { clear = true })

-- format and organize imports on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = goaugroup,
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
  end
})
