" =============================================================================
" Functions {{{1
" =============================================================================
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

" Format HTML
function! FormatHTML()
  set ft=html
  " remove trailing spaces
  call Preserve("%s/\\s\\+$//e")
  " tabs -> spaces
  call Preserve("retab")
  " re indent the file correctly
  call Preserve("normal gg=G")
endfunction

fun! VexSize(vex_width)
  execute "vertical resize" . a:vex_width
  set winfixwidth
  call NormalizeWidths()
endf

fun! NormalizeWidths()
  let eadir_pref = &eadirection
  set eadirection=hor
  set equalalways! equalalways!
  let &eadirection = eadir_pref
endf

function! VexOpen(dir)
  let g:netrw_browse_split=4    " open files in previous window
  let vex_width = 25

  execute "Vexplore " . a:dir
  let t:vex_buf_nr = bufnr("%")
  wincmd H

  call VexSize(vex_width)
endf

function! VexClose()
  let cur_win_nr = winnr()
  let target_nr = ( cur_win_nr == 1 ? winnr("#") : cur_win_nr )

  1wincmd w
  close
  unlet t:vex_buf_nr

  execute (target_nr - 1) . "wincmd w"
  call NormalizeWidths()
endf

function! VexToggle(dir)
  if exists("t:vex_buf_nr")
    call VexClose()
  else
    call VexOpen(a:dir)
  endif
endf


function! Wiki()
  let l:fzf_opts = {}
  let l:fzf_opts.sink = 'e'
  let l:fzf_opts.dir = '~/txt'
  let l:fzf_opts.source = 'ls -td $(find .)'
  let l:fzf_opts.options = '--delimiter ":" --preview="cat ~/txt/{1}" --preview-window=right:80'
  call fzf#run(fzf#wrap(l:fzf_opts))
endfunction

function! VimwikiLinkHandler(link)
  " Use Vim to open external files with the 'vfile:' scheme.  E.g.:
  "   1) [[vfile:~/Code/PythonProject/abc123.py]]
  "   2) [[vfile:./|Wiki Home]]
  let link = a:link
  if link =~# '^vfile:'
    let link = link[1:]
  else
    return 0
  endif
  let link_infos = vimwiki#base#resolve_link(link)
  if link_infos.filename == ''
    echomsg 'Vimwiki Error: Unable to resolve link!'
    return 0
  else
    exe 'edit ' . fnameescape(link_infos.filename)
    return 1
  endif
endfunction

function! SearchMarkdownLink(flag, count)
  let linkpattern = '\v\[([^\]]+)\]\(\zs([^\)]+)\ze\)'
  let i = 0
  while i < a:count
    call search(linkpattern, a:flag)
    let i += 1
  endwhile
endfunction

function! OpenJournalDate(day = "today")
  let l:now = localtime()
  let l:day = (60 * 60 * 24)
  if a:day == "yesterday"
    let l:date = strftime("%Y-%m-%d", l:now - l:day)
  else "today is default
    let l:date = strftime("%Y-%m-%d", l:now)
  endif
  exec 'edit ' . g:journal_dir . l:date . '.md'
endfunction
