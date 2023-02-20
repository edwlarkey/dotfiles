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
        { "<leader>tf", require("edwlarkey.plugins.lsp.formatting").toggle, { desc = "Toggle Autoformat" } },
        { "<leader>ww", ":Neorg workspace notes<CR>", { desc = "Open Wiki" } },
        { "<leader>wj", ":Neorg journal today<CR>", { desc = "Open Today's Journal" } },
        { "<leader>wy", ":Neorg journal yesterday<CR>", { desc = "Open Yesterday's Journal" } },
        { "<leader>wn", ":Neorg<CR>", { desc = "Open Neorg menu" } },
        { "gs", ":sort<CR>", { desc = "Sort" } },
        {
          ":<C-p>",
          function()
            require("fzf-lua").command_history()
          end,
          { desc = "FZF Command History" },
        },
        {
          "<leader>b",
          function()
            require("fzf-lua").buffers()
          end,
          { desc = "FZF Buffers" },
        },
        {
          "<leader>ff",
          function()
            require("fzf-lua").git_files()
          end,
          { desc = "FZF Git Files" },
        },
        {
          "<leader>fb",
          function()
            require("fzf-lua").builtin()
          end,
          { desc = "FZF Menu" },
        },
        {
          "<leader>fr",
          function()
            require("fzf-lua").grep()
          end,
          { desc = "FZF RipGrep" },
        },
        {
          "<leader>d",
          function()
            require("fzf-lua").files()
          end,
          { desc = "FZF Files" },
        },
        {
          "<leader>k",
          function()
            require("fzf-lua").files({ cwd = "~/txt", cmd = "fd --type f --exclude .stversions" })
          end,
          { desc = "" },
        },
        {
          "<leader>v",
          function()
            require("fzf-lua").files({ cwd = "~/dotfiles/nvim", cmd = "fd --type f" })
          end,
          { desc = "FZF Dotfiles" },
        },
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
        { "<leader>y", '"*y', { desc = "Copy to OS Clipboard" } },
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
        { "gd", vim.lsp.buf.definition, { desc = "(LSP) Get definition" } },
        { "K", vim.lsp.buf.hover, { desc = "(LSP) Get definition" } },
        { "gI", vim.lsp.buf.implementation },
        { "gr", vim.lsp.buf.references },
        { "gl", vim.diagnostic.open_float },
        { "<leader>D", vim.lsp.buf.type_definition, { desc = "(LSP) Type definition" } },
        { "<leader>lr", vim.lsp.buf.rename, { desc = "(LSP) Rename" } },
        { "<leader>la", vim.lsp.buf.code_action, { desc = "(LSP) Code Action" } },
        { "<leader>ls", vim.lsp.buf.signature_help, { desc = "(LSP) Signature Help" } },
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
          { desc = "Next Diagnostic" },
        },
        {
          "[d",
          function()
            vim.diagnostic.goto_prev({ buffer = 0 })
          end,
          { desc = "Previous Diagnostic" },
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

M.whichkey = {
  register = function()
    local wk = require("which-key")

    -- wk.register({
    --   f = {
    --     name = "file", -- optional group name
    --     f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
    --     r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap = false, buffer = 123 }, -- additional options for creating the keymap
    --     n = { "New File" }, -- just a label. don't create any mapping
    --     e = "Edit File", -- same as above
    --     ["1"] = "which_key_ignore", -- special label to hide it in the popup
    --     b = {
    --       function()
    --         print("bar")
    --       end,
    --       "Foobar",
    --     }, -- you can also pass functions!
    --   },
    -- }, { prefix = "<leader>" })
    --
    -- { "<leader>tf", require("edwlarkey.plugins.lsp.formatting").toggle },
    -- { "<leader>ww", ":Neorg workspace notes<CR>" },
    -- { "<leader>w<leader>j", ":Neorg journal today<CR>" },
    -- { "<leader>w<leader>y", ":Neorg journal yesterday<CR>" },
    -- { "<leader>wn", ":Neorg<CR>" },
    wk.register({
      ["<leader>"] = {
        w = {
          name = "Wiki",
        },
        t = {
          name = "Toggle",
        },
        f = {
          name = "FZF",
        },
      },
    })
  end,
}
return M
