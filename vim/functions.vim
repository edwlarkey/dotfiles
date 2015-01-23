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

function! Tpl(file)
  if &filetype == 'php'
      let b:dir = 'php'
  else
      let b:dir = 'misc'
  endif
  exe 'r ~/.vim/snippets/'.b:dir.'/'.a:file
endfunction

" Template inserts
:command -nargs=1 T :call Tpl(<f-args>)

