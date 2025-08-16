vim.keymap.set("n", "<space>", "<Nop>")

vim.keymap.set("n", "j", function()
  return tonumber(vim.api.nvim_get_vvar("count")) > 0 and "j" or "gj"
end, { expr = true, silent = true }) -- Move down, but use 'gj' if no count is given
vim.keymap.set("n", "k", function()
  return tonumber(vim.api.nvim_get_vvar("count")) > 0 and "k" or "gk"
end, { expr = true, silent = true }) -- Move up, but use 'gk' if no count is given
vim.keymap.set("n", "q:", ":q") -- stop command window
vim.keymap.set({ "n", "i" }, "gidt", 'a<C-R>=strftime("%Y-%m-%d %H:%M")<CR><Esc>') -- gidt to insert timestamp
vim.keymap.set({ "n", "i" }, "gid", 'a<C-R>=strftime("%Y-%m-%d")<CR><Esc>') -- gid to insert date
vim.keymap.set("n", "<leader>mv", 'ddGpA completed:<C-R>=strftime("%Y-%m-%d %H:%M")<CR><Esc>``') -- Move item to bottom and append timestamp

-- retab and format
vim.keymap.set("n", "_$", ':call Preserve("%s/\\s\\+$//e")<CR>')
vim.keymap.set("n", "<leader><tab>", ':call Preserve("retab")<CR>')
vim.keymap.set("n", "<F9>", ":call FormatHTML()<CR>")
vim.keymap.set("n", "_=", ':call Preserve("normal gg=G")<CR>')

-- test and build
vim.keymap.set("n", "<F2>", ":make test<CR>", { desc = "Run make test" })
vim.keymap.set("n", "<F3>", ":make build<CR>", { desc = "Run make build" })

-- change buffers
vim.keymap.set({ "n", "i", "v" }, "<C-h>", "<Esc>:bp<CR>")
vim.keymap.set({ "n", "i", "v" }, "<C-l>", "<Esc>:bn<CR>")

-- tmux
vim.keymap.set("n", "<C-w>h", ":TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-w>j", ":TmuxNavigateDown<CR>")
vim.keymap.set("n", "<C-w>k", ":TmuxNavigateUp<CR>")
vim.keymap.set("n", "<C-w>l", ":TmuxNavigateRight<CR>")
vim.keymap.set("n", "<C-w><C-h>", ":TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-w><C-j>", ":TmuxNavigateDown<CR>")
vim.keymap.set("n", "<C-w><C-k>", ":TmuxNavigateUp<CR>")
vim.keymap.set("n", "<C-w><C-l>", ":TmuxNavigateRight<CR>")

-- sort
vim.keymap.set("v", "gs", ":sort<CR>", { desc = "Sort" })

-- copy and paste OS
vim.keymap.set({ "n", "v" }, "<leader>y", '"*y', { desc = "Copy to OS Clipboard" })
vim.keymap.set("n", "<leader>p", 'o<ESC>"*pV`]=', { desc = "Paste from OS Clipboard and fix indentation" })
vim.keymap.set("n", "<leader>P", 'o<ESC>"*p', { desc = "Paste from OS Clipboard" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-N>") -- Exit terminal mode

--
--
-- Plugin Keymaps
--
--
vim.keymap.set("n", "<leader><space>", Snacks.picker.smart, { desc = "Smart Find Files" })
vim.keymap.set("n", "<leader>fb", Snacks.picker.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>/", Snacks.picker.grep, { desc = "Grep" })
vim.keymap.set("n", "<leader>:", Snacks.picker.command_history, { desc = "Command History" })
vim.keymap.set("n", "<leader>nH", Snacks.picker.notifications, { desc = "Notification History" })
vim.keymap.set("n", "<leader>e", Snacks.explorer.open, { desc = "File Explorer" })

-- Find
vim.keymap.set("n", "<leader>fb", Snacks.picker.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fc", function()
  Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>d", function()
  Snacks.picker.files({ hidden = true })
end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>ff", Snacks.picker.git_files, { desc = "Find Git Files" })
vim.keymap.set("n", "<leader>fp", Snacks.picker.projects, { desc = "Projects" })
vim.keymap.set("n", "<leader>fr", Snacks.picker.recent, { desc = "Recent" })

-- Git
-- vim.keymap.set({ "n", "v" }, "<leader>gB", snacks.gitbrowse, { desc = "Git Browse" })
vim.keymap.set("n", "<leader>gL", Snacks.picker.git_log_line, { desc = "Git Log Line" })
vim.keymap.set("n", "<leader>gS", Snacks.picker.git_stash, { desc = "Git Stash" })
vim.keymap.set("n", "<leader>gb", Snacks.picker.git_branches, { desc = "Git Branches" })
vim.keymap.set("n", "<leader>gd", Snacks.picker.git_diff, { desc = "Git Diff (Hunks)" })
vim.keymap.set("n", "<leader>gf", Snacks.picker.git_log_file, { desc = "Git Log File" })
-- vim.keymap.set("n", "<leader>gg", snacks.lazygit, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gl", Snacks.picker.git_log, { desc = "Git Log" })

-- Search
vim.keymap.set("n", "<leader>sC", Snacks.picker.commands, { desc = "Commands" })
vim.keymap.set("n", "<leader>sD", Snacks.picker.diagnostics_buffer, { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>sM", Snacks.picker.man, { desc = "Man Pages" })
vim.keymap.set("n", "<leader>sd", Snacks.picker.diagnostics, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sh", Snacks.picker.help, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sj", Snacks.picker.jumps, { desc = "Jumps" })
vim.keymap.set("n", "<leader>sl", Snacks.picker.loclist, { desc = "Location List" })
vim.keymap.set("n", "<leader>sm", Snacks.picker.marks, { desc = "Marks" })
vim.keymap.set("n", "<leader>sq", Snacks.picker.qflist, { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>su", Snacks.picker.undo, { desc = "Undo History" })
vim.keymap.set("n", "<leader>s/", Snacks.picker.search_history, { desc = "Search History" })
vim.keymap.set("n", "<leader>sr", Snacks.picker.registers, { desc = "Registers" })
vim.keymap.set("n", "<leader>uC", Snacks.picker.colorschemes, { desc = "Colorschemes" })

-- LSP
-- stylua: ignore start
vim.keymap.set("n", "grd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>lf", ":lua vim.lsp.buf.format()<CR>", { silent = true }) -- Format the current buffer using LSP
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "(LSP) Hover" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "(LSP) Open Float" })
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
vim.keymap.set("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
-- stylua: ignore end
