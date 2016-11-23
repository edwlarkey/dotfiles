syntax region markdownFold start="^\z(#\+\) " end="\(^#\(\z1#*\)\@!#*[^#]\)\@=" transparent fold

syn match edwTodo "\vTODO"
syn match edwDoing "\vDOING"
syn match edwHold "\vHOLD"
syn match edwDone "\vDONE"

highlight edwTodo ctermfg=Yellow
highlight edwDoing ctermfg=Cyan
highlight edwHold ctermfg=Red
highlight edwDone ctermfg=Green
