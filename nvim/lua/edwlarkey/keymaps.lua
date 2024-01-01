local M = {}

local function map(keymaps, keymap_opts, extra_opts)
  local lazy_keymaps = {}
  extra_opts = extra_opts or {}
  for modes, maps in pairs(keymaps) do
    for _, m in pairs(maps) do
      local opts = vim.tbl_extend("force", keymap_opts or {}, m[3] or {})
      if extra_opts.lazy then
        table.insert(lazy_keymaps, vim.tbl_extend("force", { m[1], m[2], mode = modes }, opts))
      else
        vim.keymap.set(modes, m[1], m[2], opts)
      end
    end
  end
  return lazy_keymaps
end

M.setup = {
  regular = function()
    map({
      [{ "n" }] = {
        { "<leader>p",     'o<ESC>"*pV`]=' },                                               -- paste from OS clipboard and fix indentation
        { "<leader>P",     'o<ESC>"*p' },                                                   -- paste from OS clipboard
        { "q:",            ":q" },                                                          -- stop command window
        { "j",             "gj" },                                                          -- go to next line on screen
        { "k",             "gk" },                                                          -- go to next line on screen
        { "gidt",          'a<C-R>=strftime("%Y-%m-%d %H:%M")<CR><Esc>' },                  -- gidt to insert timestamp
        { "gid",           'a<C-R>=strftime("%Y-%m-%d")<CR><Esc>' },                        -- gid to insert date
        { "<leader>mv",    'ddGpA completed:<C-R>=strftime("%Y-%m-%d %H:%M")<CR><Esc>``' }, -- Move item to bottom and append timestamp
        -- retab and format
        { "_$",            ':call Preserve("%s/\\s\\+$//e")<CR>' },
        { "<leader><tab>", ':call Preserve("retab")<CR>' },
        { "<F9>",          ":call FormatHTML()<CR>" },
        { "_=",            ':call Preserve("normal gg=G")<CR>' },
        { "<leader>ww",    ":Neorg workspace notes<CR>",                                 { desc = "Open Wiki" } },
        { "<leader>wj",    ":Neorg journal today<CR>",                                   { desc = "Open Today's Journal" } },
        { "<leader>wy", ":Neorg journal yesterday<CR>", {
          desc =
          "Open Yesterday's Journal"
        } },
        { "<leader>wg", ":Neorg generate-workspace-summary<CR>", { desc = "Generate Summary" } },
        { "<leader>wn", ":Neorg<CR>",                            { desc = "Open Neorg menu" } },
        { "<F2>",       ":make test<CR>",                        { desc = "Run make test" } },
        { "<F3>",       ":make build<CR>",                       { desc = "Run make build" } },
        {
          "<leader>so",
          function()
            require("resession").load()
          end,
          { desc = "Session Open" },
        },
        {
          "<leader>ss",
          function()
            require("resession").save()
          end,
          { desc = "Session Save" },
        },
        {
          "<leader>sd",
          function()
            require("resession").delete()
          end,
          { desc = "Session Delete" },
        },
        { "<leader>or", ":OverseerRun<CR>" },
        { "<leader>ot", ":OverseerToggle<CR>" },
        { "<C-w>h",     ":TmuxNavigateLeft<CR>" },
        { "<C-w>j",     ":TmuxNavigateDown<CR>" },
        { "<C-w>k",     ":TmuxNavigateUp<CR>" },
        { "<C-w>l",     ":TmuxNavigateRight<CR>" },
        { "<C-w><C-h>", ":TmuxNavigateLeft<CR>" },
        { "<C-w><C-j>", ":TmuxNavigateDown<CR>" },
        { "<C-w><C-k>", ":TmuxNavigateUp<CR>" },
        { "<C-w><C-l>", ":TmuxNavigateRight<CR>" },
      },
      [{ "n", "v" }] = {
        { "<leader>y", '"*y', { desc = "Copy to OS Clipboard" } },
      },
      [{ "n", "v", "i" }] = {
        -- C-h and C-l keys change buffers in all modes
        { "<C-h>",   "<Esc>:bp<CR>" },
        { "<C-l>",   "<Esc>:bn<CR>" },
        -- Disable arrow keys
        { "<up>",    "<nop>" },
        { "<down>",  "<nop>" },
        { "<left>",  "<nop>" },
        { "<right>", "<nop>" },
      },
      [{ "i" }] = {
        { "gidt", '<C-R>=strftime("%Y-%m-%d %H:%M")<CR>' }, -- gidt to insert timestamp
        { "gid",  '<C-R>=strftime("%Y-%m-%d")<CR>' },       -- gid to insert date
      },
      [{ "v" }] = {
        { "gs", ":sort<CR>", { desc = "Sort" } },
      },
    }, { silent = true })
  end,
  lsp = function(bufnr)
    map({
      [{ "n" }] = {
        { "gD",         vim.lsp.buf.declaration },
        { "gd",         vim.lsp.buf.definition,      { desc = "(LSP) Get definition" } },
        { "K",          vim.lsp.buf.hover,           { desc = "(LSP) Get definition" } },
        { "gl",         vim.diagnostic.open_float,   { desc = "(LSP) Open Float" } },
        { "<leader>li", vim.lsp.buf.implementation,  { desc = "(LSP) Implementations" } },
        { "<leader>lR", vim.lsp.buf.references,      { desc = "(LSP) References" } },
        { "<leader>lD", vim.lsp.buf.type_definition, { desc = "(LSP) Type definition" } },
        { "<leader>lr", vim.lsp.buf.rename,          { desc = "(LSP) Rename" } },
        { "<leader>la", vim.lsp.buf.code_action,     { desc = "(LSP) Code Action" } },
        { "<leader>ls", vim.lsp.buf.signature_help,  { desc = "(LSP) Signature Help" } },
        {
          "<leader>lf",
          function()
            vim.lsp.buf.format({ async = true })
          end,
          { desc = "(LSP) Format file" },
        },
        {
          "<leader>ld",
          function()
            require("lsp_lines").toggle()
          end,
          { desc = "(LSP) Disable virtual error lines" },
        },
        { "<leader>cl", vim.lsp.codelens.run,     { desc = "(LSP) Run Codelens" } },
        { "<leader>cr", vim.lsp.codelens.refresh, { desc = "(LSP) Refresh Codelens" } },
        {
          "]d",
          function()
            vim.diagnostic.goto_next({ buffer = 0 })
          end,
          { desc = "Next Diagnostic" },
        },
        {
          "[d",
          function()
            vim.diagnostic.goto_prev({ buffer = 0 })
          end,
          { desc = "Previous Diagnostic" },
        },
        { "<leader>lq", vim.diagnostic.setloclist, { desc = "(LSP) Set Loc List" } },
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
