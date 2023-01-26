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
        { "<leader>tf", require("edwlarkey.plugins.lsp.formatting").toggle },
        { "gs", ":sort<CR>" },
        {
          "<leader>b",
          function()
            require("fzf-lua").buffers()
          end,
        },
        {
          "<leader>f",
          function()
            require("fzf-lua").git_files()
          end,
        },
        {
          "<leader>g",
          function()
            require("fzf-lua").git_status()
          end,
        },
        {
          "<leader>d",
          function()
            require("fzf-lua").files()
          end,
        },
        {
          "<leader>k",
          function()
            require("fzf-lua").files({ cwd = "~/txt", cmd = "fd --type f --exclude .stversions" })
          end,
        },
        {
          "<leader>v",
          function()
            require("fzf-lua").files({ cwd = "~/dotfiles/nvim", cmd = "fd --type f" })
          end,
        },
        {
          "<leader>so",
          function()
            require("resession").load()
          end,
        },
        {
          "<leader>ss",
          function()
            require("resession").save()
          end,
        },
        {
          "<leader>sd",
          function()
            require("resession").delete()
          end,
        },
        { "<leader>or", ":OverseerRun<CR>" },
        { "<leader>ot", ":OverseerToggle<CR>" },
        { "<C-w>h", ":TmuxNavigateLeft<CR>" },
        { "<C-w>j", ":TmuxNavigateDown<CR>" },
        { "<C-w>k", ":TmuxNavigateUp<CR>" },
        { "<C-w>l", ":TmuxNavigateRight<CR>" },
        { "<C-w><C-h>", ":TmuxNavigateLeft<CR>" },
        { "<C-w><C-j>", ":TmuxNavigateDown<CR>" },
        { "<C-w><C-k>", ":TmuxNavigateUp<CR>" },
        { "<C-w><C-l>", ":TmuxNavigateRight<CR>" },
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
        { "gl", vim.diagnostic.open_float },
        { "<leader>D", vim.lsp.buf.type_definition },
        { "<leader>lr", vim.lsp.buf.rename },
        { "<leader>la", vim.lsp.buf.code_action },
        { "<leader>ls", vim.lsp.buf.signature_help },
        {
          "<leader>lf",
          function()
            vim.lsp.buf.format({ async = true })
          end,
        },
        { "<leader>cl", vim.lsp.codelens.run },
        { "<leader>cr", vim.lsp.codelens.refresh },
        {
          "]d",
          function()
            vim.diagnostic.goto_next({ buffer = 0 })
          end,
        },
        {
          "[d",
          function()
            vim.diagnostic.goto_prev({ buffer = 0 })
          end,
        },
        { "<leader>lq", vim.diagnostic.setloclist },
      },
    }, { remap = false, silent = true, buffer = bufnr })
    map({
      [{ "v" }] = {
        { "<leader>la", vim.lsp.buf.code_action },
      },
    }, { remap = false, silent = true, buffer = bufnr })
  end,
  gitsigns = function(bufnr)
    local gs = require("gitsigns")
    map({
      [{ "n" }] = {
        {
          "]g",
          function()
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end,
        },
        {
          "[g",
          function()
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end,
        },
        {
          "<leader>hb",
          function()
            require("gitsigns").blame_line()
          end,
        },
        {
          "<leader>hB",
          function()
            gs.blame_line({ full = true })
          end,
        },
        {
          "<leader>hD",
          function()
            gs.diffthis("~")
          end,
        },
        {
          "<leader>hd",
          function()
            gs.diffthis()
          end,
        },
        {
          "<leader>hp",
          function()
            gs.preview_hunk()
          end,
        },
      },
    }, { remap = false, silent = true, buffer = bufnr })
  end,
}

M.cmp = {
  insert = function()
    local cmp = require("cmp")
    return cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<TAB>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    })
  end,
}

return M
