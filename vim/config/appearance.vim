" =============================================================================
" Appearance {{{1
" =============================================================================

set cursorline      " Highlight current line
set scrolloff=5     " Keep more buffer context when scrolling
set cmdheight=1     " Set command line height (default)
set title           " Show the filename in the window titlebar
set t_Co=256         " 256 colors
set background=dark " Dark background
set noerrorbells    " Disable error bells
set number          " Show line numbers
set relativenumber  " Relative numbering
syntax on
syntax enable

""
"" Statusline
""

set noruler
set laststatus=2
set statusline=
set statusline+=%t\       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}]\  "file format
set statusline+=%y\      "filetype
set statusline+=%h\      "help file flag
set statusline+=%m\      "modified flag
set statusline+=%r\      "read only flag
set statusline+=%=      "left/right separator
set statusline+=line:%l/%L\    "cursor line/total lines
set statusline+=col:%c\     "cursor column
set statusline+=\ %P    "percent through file

""
"" Colorscheme and colorcolumn
""

" let g:solarized_termcolors=16
let base16colorspace=256
try
  colorscheme base16-eighties
catch
  colorscheme default
endtry

" dont display color column if it doesn't support it
if v:version > 703
  let &colorcolumn="80,".join(range(120,999),",")
endif

""
"" Whitespace
""

"indentation
set expandtab     " Tab in insert mode will produce spaces
set tabstop=2     " Width of a tab
set shiftwidth=2  " Width of reindent operations and auto indentation
set softtabstop=2 " Set spaces for tab in insert mode
set autoindent    " Enable auto indentation
set copyindent    " Copy indentation from source
set smarttab
set nowrap        " Don't wrap lines

" Tabs for various file types.
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype python setlocal ts=4 sw=4 expandtab
autocmd Filetype php setlocal ts=4 sw=4 expandtab
autocmd Filetype css setlocal ts=4 sw=4 expandtab
autocmd Filetype scss setlocal ts=4 sw=4 expandtab
autocmd Filetype snippets setlocal ts=4 sw=4 expandtab
autocmd Filetype markdown,mkd,md setlocal ts=4 sw=4 expandtab
autocmd Filetype perl setlocal ts=4 sw=4 expandtab
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
autocmd FileType calendar set noexpandtab shiftwidth=8 softtabstop=0

" Invisible characters
set list
set listchars=tab:>·,trail:·,extends:#,nbsp:.
autocmd filetype html,xml set listchars-=tab:>·
