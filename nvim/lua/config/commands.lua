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
]])
