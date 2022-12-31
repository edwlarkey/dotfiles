vim.cmd([[
" Tabs for various file types.
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype python setlocal ts=4 sw=4 expandtab
autocmd Filetype php setlocal ts=4 sw=4 expandtab
autocmd Filetype css setlocal ts=2 sw=2 expandtab
autocmd Filetype scss setlocal ts=2 sw=2 expandtab
autocmd Filetype snippets setlocal ts=4 sw=4 expandtab
autocmd Filetype markdown,mkd,md setlocal ts=4 sw=4 expandtab
autocmd Filetype perl setlocal ts=4 sw=4 expandtab
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
autocmd FileType calendar set noexpandtab shiftwidth=8 softtabstop=0

augroup go
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd FileType go set listchars=tab:\ \ 
augroup END

au BufRead,BufNewFile *.php set ft=html.php
au BufRead,BufNewFile *.py set ft=python
au BufRead,BufNewFile *.scss set ft=css
au BufRead,BufNewFile *.jira set ft=jira
au BufRead,BufNewFile *.rb set ft=ruby.chef
au BufRead,BufNewFile */cloudformation/**/*.yml,*/cloudformation/**/*.yaml set ft=yaml.cloudformation

"Spelling
autocmd FileType gitcommit,mail,md,markdown,mkd,jira,tex,vimwiki set spell

" Grep quickfix
autocmd QuickFixCmdPost *grep* cwindow

"Markdown files textwidth
augroup markdown
  au BufRead,BufNewFile *.md setlocal textwidth=79
  au FileType markdown setlocal textwidth=79
  au FileType markdown setlocal conceallevel=2
augroup END

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
