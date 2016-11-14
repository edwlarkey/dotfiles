syntax region markdownFold start="^\z(#\+\) " end="\(^#\(\z1#*\)\@!#*[^#]\)\@=" transparent fold

syn match edwTodo "\vTODO"
syn match edwDoing "\vDOING"
syn match edwDone "\vDONE"

highlight edwTodo ctermfg=Green
highlight edwDoing ctermfg=Yellow
highlight edwDone ctermfg=Cyan
