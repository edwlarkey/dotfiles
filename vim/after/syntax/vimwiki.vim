syn match edwTodo "\vTODO"
syn match edwDoing "\vDOING"
syn match edwHold "\vHOLD"
syn match edwDone "\vDONE"
syn match edwDue "\vDUE:|COMPLETED:"
syn match edwDate "\d\d\d\d-\d\d-\d\d"

highlight edwTodo ctermfg=Yellow
highlight edwDoing ctermfg=Cyan
highlight edwHold ctermfg=Red
highlight edwDone ctermfg=Green
highlight edwDue ctermfg=Magenta
highlight edwDate ctermfg=Blue
