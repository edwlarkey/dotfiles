local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

--
-- Backup, swap, undo
--
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("data") .. "/vim-backup/"
vim.opt.writebackup = true
vim.opt.directory = vim.fn.stdpath("data") .. "/vim-swap/"
vim.opt.undofile = true

--
-- Search
--
vim.opt.showmatch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

--
-- Appearance
--
vim.opt.scrolloff = 5
vim.opt.cmdheight = 1
vim.opt.title = true
vim.opt.number = true
vim.opt.syntax = "on"
vim.opt.viewoptions = "cursor,folds,slash,unix"
vim.opt.ruler = false
vim.opt.errorbells = true
vim.opt.vb = false
vim.opt.colorcolumn = "80,120"

--
-- Statusline
--
vim.opt.statusline:append("%t ") -- filename
vim.opt.statusline:append("[%{strlen(&fenc)?&fenc:'none'}") -- encoding
vim.opt.statusline:append("%{&ff}]") -- file format
vim.opt.statusline:append("%y") -- filetype
vim.opt.statusline:append("%h") -- help file flag
vim.opt.statusline:append("%m") -- modified flag
vim.opt.statusline:append("%r") -- read only flag
vim.opt.statusline:append("%=") -- left/right separator
vim.opt.statusline:append("line:%l/%L ") -- cursor line/total lines
vim.opt.statusline:append("col:%c ") -- cursor column
vim.opt.statusline:append("%P") -- percent through file

--
-- Whitespace
--
--
vim.opt.joinspaces = false
vim.opt.startofline = false
vim.opt.pastetoggle = "<F2>" -- no autodindent with F2

-- Indentation
vim.opt.expandtab = true -- Tab in insert mode will produce spaces
-- " vim.opt.tabstop=2      -- Width of a tab
vim.opt.shiftwidth = 2 -- Width of reindent operations and auto indentation
vim.opt.softtabstop = 2 -- Set spaces for tab in insert mode
vim.opt.autoindent = true -- Enable auto indentation
vim.opt.copyindent = true -- Copy indentation from source
vim.opt.wrap = false -- Don't wrap lines

-- Invisible characters
vim.opt.list = true
vim.opt.listchars = "tab:>·,trail:·,extends:#,nbsp:."

vim.opt.termguicolors = true
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
