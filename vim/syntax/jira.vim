highlight jiraMarkOn ctermfg=Yellow guifg=yellow
highlight jiraMarkOff ctermfg=DarkGrey guifg=darkgrey
highlight jiraMarkCheck ctermfg=DarkGreen guifg=green
highlight jiraMarkError ctermfg=Red guifg=red
highlight jiraMarkWarn ctermfg=202 guifg=#ff5f00
highlight jiraMarkYes ctermfg=DarkGreen guifg=green
highlight jiraMarkNo ctermfg=Red guifg=red
highlight jiraMarkInfo ctermfg=Blue guifg=blue

highlight link jiraPanelTitle Title
highlight hide guifg=darkgrey ctermfg=darkgrey
highlight link jiraPanelEnd hide
highlight jiraBold gui=bold cterm=bold
highlight jiraItalic gui=italic cterm=underline

syntax match jiraMarkOn    /(on)/
syntax match jiraMarkOff   /(off)/
syntax match jiraMarkCheck /(\/)/
syntax match jiraMarkError /(x)/
syntax match jiraMarkWarn  /(!)/
syntax match jiraMarkYes   /(y)/
syntax match jiraMarkNo    /(n)/
syntax match jiraMarkInfo  /(?)/
syntax cluster jiraMark contains=jiraMarkOn,jiraMarkOff,jiraMarkCheck,jiraMarkError,jiraMarkWarn,jiraMarkYes,jiraMarkNo

syntax match jiraItalic /_[^_]\+_/ excludenl contains=ALL
syntax match jiraBold /\*[^*]\+\*/ excludenl contains=ALL

syntax region jiraNoFormat matchgroup=hide start="{noformat}" end="{noformat}" keepend

syntax region jiraPanel start="{panel:" end="{panel}" fold contains=ALL keepend
syntax region jiraPanelTitle matchgroup=hide start="{panel:.\{-}\(title=\)" end="|.*}" contained 
syntax match jiraPanelEnd /{panel}/ contained

highlight link jiraTableHeader jiraBold
syntax region jiraTableHeader start="^\s*||" end="||\s*$" contains=ALL
syntax region jiraTableRow start="^\s*|" end="|\s*$" contains=ALL

set foldmethod=syntax
