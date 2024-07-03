vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "gitcommit",
    "mail",
    "norg",
  },
  callback = function()
    vim.wo.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "html",
    "css",
  },
  callback = function()
    vim.o.tabstop = 2
    vim.o.shiftwidth = 2
    vim.o.expandtab = true
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "python",
  },
  callback = function()
    vim.o.tabstop = 4
    vim.o.shiftwidth = 4
    vim.o.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "pkl",
  callback = function()
    vim.opt.foldmethod = "manual"
  end,
})

local markdown_group = vim.api.nvim_create_augroup("markdown", { clear = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "markdown",
  },
  group = markdown_group,
  callback = function()
    vim.o.tabstop = 4
    vim.o.shiftwidth = 4
    vim.o.expandtab = true
    vim.wo.spell = true
    vim.o.textwidth = 79
    vim.o.conceallevel = 2
  end,
})

local neorg_group = vim.api.nvim_create_augroup("neorg_group", { clear = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "norg",
  },
  group = neorg_group,
  callback = function()
    vim.wo.spell = true
    vim.o.textwidth = 79
    vim.o.conceallevel = 2
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "*.tex",
  },
  callback = function()
    vim.o.textwidth = 79
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "make",
    "calendar",
  },
  callback = function()
    vim.opt.softtabstop = 0
    vim.opt.shiftwidth = 8
    vim.opt.expandtab = false
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = {
    "*",
  },
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
})

vim.filetype.add({
  -- extension = {},
  -- filename = {},
  pattern = {
    -- can be comma-separated for a list of paths
    [".*/%.github/dependabot.yml"] = "dependabot",
    [".*/%.github/dependabot.yaml"] = "dependabot",
    [".*/%.github/workflows[%w/]+.*%.yml"] = "gha",
    [".*/%.github/workflows/[%w/]+.*%.yaml"] = "gha",
  },
})

-- use the yaml parser for the custom filetypes
vim.treesitter.language.register("yaml", "gha")
vim.treesitter.language.register("yaml", "dependabot")

vim.cmd([[

" https://vim.fandom.com/wiki/Automatically_open_the_quickfix_window_on_:make
" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
"
" Note: Must allow nesting of autocmds to enable any customizations for quickfix
" buffers.
" Note: Normally, :cwindow jumps to the quickfix window if the command opens it
" (but not if it's already open). However, as part of the autocmd, this doesn't
" seem to happen.
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

augroup textcal
  autocmd BufRead,BufNewFile */txt/calendar/* set filetype=textcal
  autocmd BufRead,BufNewFile */txt/calendar/* set spell
  autocmd BufRead,BufNewFile */txt/calendar/* set hlsearch
  autocmd BufRead,BufNewFile */txt/calendar/* exe '/'.strftime("%Y-%m-%d")
  autocmd Filetype textcal setlocal ts=16 sw=16 expandtab
augroup END

" Markdown
let g:vim_markdown_folding_disabled = 1

function! Preserve(command)
  " Preparation save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction


function! MarkdownNeorg()
  call Preserve("%s/^#####/*****/e")
  call Preserve("%s/^####/****/e")
  call Preserve("%s/^###/***/e")
  call Preserve("%s/^##/**/e")
  call Preserve("%s/^#/*/e")
  call Preserve("%s/(/{/e")
  call Preserve("%s/)/}/e")
  call Preserve("%s/\.md//e")
endfunction
]])
