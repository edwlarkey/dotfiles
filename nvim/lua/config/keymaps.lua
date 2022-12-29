local M = {}

local function map(mappings, opts)
  for mode, mapping_table in pairs(mappings) do
    for _, mapping in pairs(mapping_table) do
      local key = mapping[1]
      local cmd = mapping[2]
      opts = vim.tbl_deep_extend("force", mapping[3] or {}, opts or {})
      vim.keymap.set(mode, key, cmd, opts)
    end
  end
end

M.setup = {
  regular = function()
    map({
      [{ "n" }] = {
        { "<leader>p", 'o<ESC>"*pV`]=' }, -- paste from OS clipboard and fix indentation
        { "<leader>P", 'o<ESC>"*p' }, -- paste from OS clipboard
        { "q:", ":q" }, -- stop command window
        { "j", "gj" }, -- go to next line on screen
        { "k", "gk" }, -- go to next line on screen
        { "gidt", 'a<C-R>=strftime("%Y-%m-%d %H:%M")<CR><Esc>' }, -- gidt to insert timestamp
        { "gid", 'a<C-R>=strftime("%Y-%m-%d")<CR><Esc>' }, -- gid to insert date
        { "<leader>mv", 'ddGpA completed:<C-R>=strftime("%Y-%m-%d %H:%M")<CR><Esc>``' }, -- Move item to bottom and append timestamp
        -- retab and format
        { "_$", ':call Preserve("%s/\\s\\+$//e")<CR>' },
        { "<leader><tab>", ':call Preserve("retab")<CR>' },
        { "<F9>", ":call FormatHTML()<CR>" },
        { "_=", ':call Preserve("normal gg=G")<CR>' },
      },
      [{ "n", "v" }] = {
        { "<leader>y", '"*y' }, -- copy to OS clipboard
      },
      [{ "n", "v", "i" }] = {
        -- C-h and C-l keys change buffers in all modes
        { "<C-h>", "<Esc>:bp<CR>" },
        { "<C-l>", "<Esc>:bn<CR>" },
        -- Disable arrow keys
        { "<up>", "<nop>" },
        { "<down>", "<nop>" },
        { "<left>", "<nop>" },
        { "<right>", "<nop>" },
      },
      [{ "i" }] = {
        { "gidt", '<C-R>=strftime("%Y-%m-%d %H:%M")<CR>' }, -- gidt to insert timestamp
        { "gid", '<C-R>=strftime("%Y-%m-%d")<CR>' }, -- gid to insert date
      },
    }, { silent = true })
  end,
  lsp = function(bufnr)
    map({
      [{ "n" }] = {
        { "gD", vim.lsp.buf.declaration },
        { "gd", vim.lsp.buf.definition },
        { "K", vim.lsp.buf.hover },
        { "gI", vim.lsp.buf.implementation },
        { "gr", vim.lsp.buf.references },
        { "gl", vim.diagnostic.open_float() },
        { "<leader>D", vim.lsp.buf.type_definition },
        { "<leader>lr", vim.lsp.buf.rename },
        { "<leader>la", vim.lsp.buf.code_action },
        {
          "<leader>lf",
          function()
            vim.lsp.buf.format({ async = true })
          end,
        },
        { "<leader>la", vim.lsp.buf.code_action() },
        { "<leader>lj", vim.diagnostic.goto_next({ buffer = 0 }) },
        { "<leader>lk", vim.diagnostic.goto_prev({ buffer = 0 }) },
        { "<leader>ls", vim.lsp.buf.signature_help() },
        { "<leader>lq", vim.diagnostic.setloclist() },
      },
    }, { remap = false, silent = true, buffer = bufnr })
  end,
}

M.cmp = {
  insert = function()
    local cmp = require('cmp')
    return cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<TAB>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    })
  end,
}

return M
