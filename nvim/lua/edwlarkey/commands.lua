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

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
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
  pattern = {
    "go",
  },
  callback = function()
    vim.opt.listchars = "tab:  "
  end,
})

-- "Markdown files textwidth
-- augroup markdown
--   au BufRead,BufNewFile *.md setlocal textwidth=79
--   au FileType markdown setlocal textwidth=79
--   au FileType markdown setlocal conceallevel=2
-- augroup END
--
-- " LaTeX
-- au BufRead,BufNewFile *.tex setlocal textwidth=79
-- " autocmd FileType tex setlocal makeprg=pdflatex\ '%'
--
-- " Comments
-- autocmd FileType gitcommit set commentstring=#\ %s

vim.cmd([[
" LaTeX
au BufRead,BufNewFile *.tex setlocal textwidth=79
" autocmd FileType tex setlocal makeprg=pdflatex\ '%'

" Comments
autocmd FileType gitcommit set commentstring=#\ %s

augroup textcal
  autocmd BufRead,BufNewFile */txt/calendar/* set filetype=textcal
  autocmd BufRead,BufNewFile */txt/calendar/* set spell
  autocmd BufRead,BufNewFile */txt/calendar/* set hlsearch
  autocmd BufRead,BufNewFile */txt/calendar/* exe '/'.strftime("%Y-%m-%d")
  autocmd Filetype textcal setlocal ts=16 sw=16 expandtab
augroup END

let g:toggler_keywords = [
  \ ['TODO', 'DOING', 'DONE'],
  \ ['True', 'False'],
  \ ['YES', 'NO'],
  \ ['\[ \]', '\[x\]'],
  \ ['x', '/'],
  \]

" =============================================================================
" Wiki and calendar {{{1
" =============================================================================
let g:text_dir = '$HOME/txt/'
let g:journal_dir = g:text_dir . 'journal/'
nnoremap <leader>w :e $HOME/txt/index.md<cr>
nnoremap <leader>w<leader>c :e +/<C-R>=strftime("%Y-%m-%d")<CR> $HOME/txt/calendar/2021.txt<CR>
nnoremap <leader>w<leader>j :call OpenJournalDate()<CR>
nnoremap <leader>w<leader>y :call OpenJournalDate("yesterday")<CR>
nnoremap <leader>w<leader>l :call AddLink()<CR>

" Markdown
let g:vim_markdown_folding_disabled = 1
]])
