local M = {
  "jose-elias-alvarez/null-ls.nvim",
}

function M.setup(options)
  local null_ls = require("null-ls")
  local formatting = null_ls.builtins.formatting
  null_ls.setup({
    debug = false,
    sources = {
      formatting.isort,
      formatting.prettier.with({
        extra_filetypes = { "toml" },
        extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
      }),
      formatting.black.with({ extra_args = { "--fast" } }),
      formatting.stylua.with({
        extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      }),
    },
    on_attach = options.on_attach,
    root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git"),
  })
end

function M.has_formatter(ft)
  local sources = require("null-ls.sources")
  local available = sources.get_available(ft, "NULL_LS_FORMATTING")
  return #available > 0
end

return M
