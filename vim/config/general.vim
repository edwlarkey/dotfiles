" =============================================================================
" General Config {{{1
" =============================================================================

" Use UTF-8 without BOM
set encoding=utf-8 nobomb

" Use <SPACE> as leader
let mapleader=" "
let maplocalleader=","

" Stop that stupid window
map q: :q

filetype plugin indent on
" Backspace over everything in insert mode
set backspace=indent,eol,start

" Tags
set tags=./tags,tags,~/.worktags;

" Spelling file
set spellfile+=~/txt/spellfile.add

" Allow unsaved background buffers and remember marks/undo for them
set hidden

" Auto-reload buffers when files are changed on disk
set autoread

""
"" Joining
""

" Use only 1 space after "." when joining lines instead of 2
set nojoinspaces

" Joining with indents is useless - instead join and delete spaces
nnoremap gJ Jdiw

" Don't reset cursor to start of line when moving around
set nostartofline

""
"" Fuzzy finding
""
set path+=~/txt/**
set path+=**

" Make tab completion for files/buffers act like bash
set wildmenu

" Use emacs-style tab completion when selecting files, etc
set wildmode=longest,list

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Ignore node modules
set wildignore+=*/node_modules/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*
set wildignore=*.bak,*.pyc,*.class

""
"" Backup, swap, undo
""
set backup
set backupdir=~/.vim-backup//
set directory=~/.vim-swap//
set undofile
set undodir=~/.vim-undo//
set writebackup

""
"" Search
""
set showmatch  " Show matches
set hlsearch   " Highlight searches
set incsearch  " Highlight dynamically as pattern is typed
set ignorecase " Make searches case-insensitive...
set smartcase  " ...unless they contain at least one uppercase character
