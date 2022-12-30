" Edward Larkey's vimrc
"
" Snippets were taken from many places over the years.
"
" Clear autocmds
autocmd!

set nocompatible    " Use Vim settings, rather than Vi settings

filetype off        "required
let g:ale_completion_enabled = 0

if !empty(glob("~/.vim/functions.vim"))
  source ~/.vim/functions.vim
endif

" =============================================================================
" Snippets {{{1
" =============================================================================
" Read an empty HTML template and move cursor to title
nnoremap ,html :-1read $HOME/.vim/templates/html<CR>4jwf>a


" =============================================================================
" General Config {{{1
" =============================================================================

" set encoding=utf-8 nobomb " Use UTF-8 without BOM
"
" " Use <SPACE> as leader
" let mapleader=" "
" let maplocalleader=","
"
" filetype plugin indent on


" =============================================================================
" Appearance {{{1
" =============================================================================

" set cursorline    " Highlight current line
" set t_Co=256      " 256 colors
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif



" =============================================================================
" Registers
" =============================================================================

" =============================================================================
" General Keybindings
" =============================================================================

" Joining with indents is useless - instead join and delete spaces
" nnoremap gJ Jdiw


" quick vimrc editing
" The autocmd should be in another secion, but I like it all together
" :nnoremap <leader>v :e $MYVIMRC<cr>
" autocmd BufWritePost .vimrc source %



" =============================================================================
" Filetypes and Custom Autocmds {{{1
" =============================================================================


" Completion
" set omnifunc=syntaxcomplete#Complete
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP


" If you prefer the Omni-Completion tip window to close when a selection is
" " made, these lines close it on movement in insert mode or when leaving
" " insert mode
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" =============================================================================
" Plugin Settings and Mappings {{{1
" =============================================================================


" netrw
" open from current directory
" nnoremap <leader>n :call VexToggle(getcwd())<CR>
" let g:netrw_liststyle= 3
" open from current file
" nnoremap <leader>n :call VexToggle("")<CR>

" Toggler
:nnoremap <F8> :Toggle<CR>
let g:toggler_keywords = [
  \ ['TODO', 'DOING', 'DONE'],
  \ ['True', 'False'],
  \ ['YES', 'NO'],
  \ ['\[ \]', '\[x\]'],
  \ ['x', '/'],
  \]

" vim-go plugin settings

" Regular vim-go settings
let g:go_fmt_command = "goimports"
let g:go_rename_command = "gopls"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_auto_type_info = 1
let g:go_doc_balloon = 1
let g:go_doc_popup_window = 1
let g:go_metalinter_command = "golangci-lint"
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>b <Plug>(go-build)
" autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <leader>e <Plug>(go-decls)
autocmd FileType go nmap <leader>w <Plug>(go-decls-dir)
autocmd FileType go nmap <leader>r <Plug>(go-def)
autocmd FileType go nmap gie <Plug>(go-iferr)
autocmd FileType go imap gie <ESC><Plug>(go-iferr)2kA
autocmd FileType go nmap <silent> <Leader>i <Plug>(go-doc)

" fzf
" nmap <Leader>l :Buffers<CR>
" nmap <Leader>f :GFiles<CR>
" nmap <Leader>g :GFiles?<CR>
" nmap <Leader>d :Files<CR>
" nmap <Leader>k :call Wiki()<CR>

" vim-autoformat
noremap <F3> :Autoformat<CR>

" tmux-navigator
let g:tmux_navigator_no_mappings = 1
nmap <silent> <C-w>h :TmuxNavigateLeft<cr>
nmap <silent> <C-w>j :TmuxNavigateDown<cr>
nmap <silent> <C-w>k :TmuxNavigateUp<cr>
nmap <silent> <C-w>l :TmuxNavigateRight<cr>

" easier window navigation with ctrl pressed
nmap <silent> <C-w><C-h> :TmuxNavigateLeft<cr>
nmap <silent> <C-w><C-j> :TmuxNavigateDown<cr>
nmap <silent> <C-w><C-k> :TmuxNavigateUp<cr>
nmap <silent> <C-w><C-l> :TmuxNavigateRight<cr>

" =============================================================================
" Wiki and calendar {{{1
" =============================================================================
let g:text_dir = '$HOME/txt/'
let g:journal_dir = g:text_dir . 'journal/'
nnoremap <leader>w :e $HOME/txt/index.md<cr>
nnoremap <leader>w<leader>c :e +/<C-R>=strftime("%Y-%m-%d")<CR> $HOME/txt/calendar/2021.txt<CR>
nnoremap <leader>w<leader>j :call OpenJournalDate()<CR>
nnoremap <leader>w<leader>y :call OpenJournalDate("yesterday")<CR>
nnoremap <leader>w<leader>l :call AddLink()<CR>
if !has('nvim')
  " Next markdown link
  nnoremap <tab> :call SearchMarkdownLink('s', 1)<CR>
  " Previous markdown link
  nnoremap <s-tab> :call SearchMarkdownLink('bs', 1)<CR>

  autocmd FileType markdown nmap <buffer> <Enter> <Plug>Markdown_EditUrlUnderCursor
endif

augroup textcal
  autocmd BufRead,BufNewFile */txt/calendar/* set filetype=textcal
  autocmd BufRead,BufNewFile */txt/calendar/* set spell
  autocmd BufRead,BufNewFile */txt/calendar/* set hlsearch
  autocmd BufRead,BufNewFile */txt/calendar/* exe '/'.strftime("%Y-%m-%d")
  autocmd Filetype textcal setlocal ts=16 sw=16 expandtab
augroup END


" Markdown
let g:vim_markdown_folding_disabled = 1

" Check for local settings for env specific settings. e.g. Work specific
" config
"
if !empty(glob("~/.local.vimrc"))
  source ~/.local.vimrc
endif
