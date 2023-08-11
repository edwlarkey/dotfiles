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

local goaugroup = vim.api.nvim_create_augroup("goformat", { clear = true })

-- format and organize imports on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = goaugroup,
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
  end
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = goaugroup,
  pattern = {
    "*.go",
  },
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = false
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = goaugroup,
  pattern = {
    "go",
  },
  callback = function()
    vim.opt.listchars = "tab:  "
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

vim.cmd([[

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
