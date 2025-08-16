local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local opt = vim.opt

opt.signcolumn = "yes:1" -- Always show sign column
opt.cursorline = true -- Highlight the current line
opt.scrolloff = 8 -- Keep 8 lines above and below the cursor
opt.inccommand = "nosplit" -- Shows the effects of a command incrementally in the buffer
opt.completeopt = { "menuone", "popup", "noinsert" } -- Options for completion menu
opt.winborder = "rounded" -- Use rounded borders for windows

--
-- Backup, swap, undo
--
opt.backup = true
opt.writebackup = true
vim.opt.backupdir = vim.fn.stdpath("data") .. "/vim-backup/"
opt.undofile = true
opt.directory = vim.fn.stdpath("data") .. "/vim-swap/"

--
-- Search
--
opt.showmatch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

--
-- Appearance
--
opt.updatetime = 150
opt.scrolloff = 5
opt.cmdheight = 1
opt.title = true
opt.number = true
opt.numberwidth = 2 -- Width of the line number column
opt.syntax = "on"
opt.viewoptions = "cursor,folds,slash,unix"
opt.ruler = false
opt.errorbells = true
opt.vb = false
opt.colorcolumn = "80,120"
opt.termguicolors = true -- Enable true colors

--
-- Whitespace
--
--
opt.joinspaces = false
opt.startofline = false

-- Indentation
opt.tabstop = 2 -- Number of spaces for a tab
opt.shiftround = true -- Round indent to multiple of shiftwidth
vim.opt.expandtab = true -- Tab in insert mode will produce spaces
vim.opt.shiftwidth = 2 -- Width of reindent operations and auto indentation
vim.opt.softtabstop = 2 -- Set spaces for tab in insert mode
vim.opt.autoindent = true -- Enable auto indentation
vim.opt.copyindent = true -- Copy indentation from source
vim.opt.wrap = false -- Don't wrap lines

-- Invisible characters
opt.list = true
opt.listchars = "tab:>·,trail:·,extends:#,nbsp:."

if file_exists(os.getenv("HOME") .. "/light") then
  vim.opt.background = "light"
else
  vim.opt.background = "dark"
end

vim.g.clipboard = {
  name = "tmuxclipboard",
  copy = {
    ["+"] = "tmux load-buffer -w -",
    ["*"] = "tmux load-buffer -w -",
  },
  paste = {
    ["+"] = "tmux save-buffer -",
    ["*"] = "tmux save-buffer -",
  },
}

vim.cmd.filetype("plugin indent on") -- Enable filetype detection, plugins, and indentation
