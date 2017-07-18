syntax case ignore

syn match edwTodo "\vTODO"
syn match edwDoing "\vDOING"
syn match edwHold "\vHOLD"
syn match edwDone "\vDONE"
syn match edwDue "\vdue:\d\d\d\d-\d\d-\d\d"
syn keyword edwqqqqq qqqqq
syn keyword edwqqqq qqqq
syn keyword edwqqq qqq
syn keyword edwqq qq

syn match textcalKeywords "\vNatasha\'s|Natasha|Vasily|Vasily\'s|Vasya|Vasya\'s"
syn match textcalSpecial "\vbirthday"
syn match textcalHashtag '#[A-Za-z0-9:]*\w'
syn match textcalAt '@[A-Za-z0-9:]*\w'
syn match textcalWork '\v\#work'
syn match textcalCanceled '\v\#canceled'


highlight edwTodo ctermfg=Yellow
highlight edwDoing ctermfg=Cyan
highlight edwHold ctermfg=Red
highlight edwDone ctermfg=Green
highlight link edwqqqqq ErrorMsg
highlight link edwqqqq ModeMsg
highlight link edwqqq MoreMsg
highlight link edwqq Question
highlight link edwDue PMenu
highlight link textcalHashtag Constant
highlight link textcalAt PreProc
highlight link textcalWork Error
highlight link textcalCanceled PMenu
highlight link textcalKeywords Todo
highlight link textcalSpecial PreProc
