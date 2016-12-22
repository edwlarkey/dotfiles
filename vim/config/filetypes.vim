" =============================================================================
" Filetypes and Custom Autocmds {{{1
" =============================================================================

au BufRead *.php set ft=html.php
au BufNewFile *.php set ft=html.php
au BufRead *.py set ft=python
au BufNewFile *.py set ft=python
au BufRead *.scss set ft=css
au BufNewFile *.scss set ft=css
au BufRead *.jira set ft=jira
au BufNewFile *.jira set ft=jira

"Spelling
autocmd FileType gitcommit,mail,md,markdown,mkd,jira,tex,vimwiki set spell

" Grep quickfix
autocmd QuickFixCmdPost *grep* cwindow

"Markdown files textwidth
au BufRead,BufNewFile *.md setlocal textwidth=79
au BufRead,BufNewFile *.md setlocal textwidth=79
au BufRead,BufNewFile *.md,*.markdown setlocal foldlevel=1
" au BufRead,BufNewFile *.md,*.markdown setlocal fdm=syntax
autocmd FileType markdown set foldmethod=syntax

" PyLint
" autocmd FileType python set makeprg=pylint\ --reports=n\ --msg-template=\"{path}:{line}:\ {msg_id}\ {symbol},\ {obj}\ {msg}\"\ %:p
" autocmd FileType python set errorformat=%f:%l:\ %m

" LaTeX
au BufRead,BufNewFile *.tex setlocal textwidth=79
au BufRead,BufNewFile *.tex setlocal textwidth=79
" autocmd FileType tex setlocal makeprg=pdflatex\ '%'

" Make on write
" autocmd BufWritePost *.py Make

" QuickFix on make
"autocmd QuickFixCmdPost * copen

" Comments
autocmd FileType gitcommit set commentstring=#\ %s

" Completion
set completeopt=longest,menuone,preview
set omnifunc=syntaxcomplete#Complete
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
autocmd InsertLeave * if pumvisible() == 0|pclose|endif


" If you prefer the Omni-Completion tip window to close when a selection is
" " made, these lines close it on movement in insert mode or when leaving
" " insert mode
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
