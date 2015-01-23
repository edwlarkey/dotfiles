"""""""""""""""""""""""""""""""""""""""""""""""""
" FUNCTIONS
"""""""""""""""""""""""""""""""""""""""""""""""""
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

function! PhpDoc()
  " Insert docblock
  exe 'r ~/.vim/snippets/php/doc'
endfunction

function! PhpDocHead()
  " Insert docblock
  exe 'r ~/.vim/snippets/php/doc_h'
endfunction

" PHP template inserts
:command Pdoc :call PhpDoc()
:command Phdoc :call PhpDocHead()

