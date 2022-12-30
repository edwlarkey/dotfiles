local M = {
  "williamboman/mason.nvim",
}

M.tools = {
  "stylua",
  "shellcheck",
  "black",
  "isort",
}

M.servers = {
  "sumneko_lua",
  "pylsp",
  "gopls",
  "bashls",
  "jsonls",
  "yamlls",
}

function M.check()
  local mr = require("mason-registry")
  for _, tool in ipairs(M.tools) do
    local p = mr.get_package(tool)
    if not p:is_installed() then
      p:install()
    end
  end
end

function M.config()
  require("mason").setup()
  M.check()
  require("mason-lspconfig").setup({
    ensure_installed = M.servers,
    automatic_installation = true,
  })
end

return M
