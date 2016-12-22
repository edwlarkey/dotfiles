" Left/Right arrow keys change buffers in all modes
noremap <Left> <Esc>:bp<CR>
inoremap <Left> <Esc>:bp<CR>
nnoremap <Left> <Esc>:bp<CR>
vnoremap <Left> <Esc>:bp<CR>

noremap <Right> <Esc>:bn<CR>
inoremap <Right> <Esc>:bn<CR>
nnoremap <Right> <Esc>:bn<CR>
vnoremap <Right> <Esc>:bn<CR>

" =============================================================================
" Registers
" =============================================================================

" Use the OS clipboard by default
" set clipboard=unnamed

" Copy to X11 primary clipboard
" map <leader>y "*y

" Paste from unnamed register and fix indentation
" nmap <leader>p pV`]=

" Delete to the blackhole register
" nnoremap <leader>x "_x
" nnoremap <leader>d "_dd

inoremap <s-tab> <c-x><c-o>

" =============================================================================
" General Keybindings
" =============================================================================

" quick vimrc editing
:nnoremap <leader>v :e $MYVIMRC<cr>
autocmd BufWritePost .vimrc source %

" Make
nmap <leader>m :Make<CR>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" go to next line on screen
nnoremap j gj
nnoremap k gk

" Disable up/down arrow keys
" noremap <up> <nop>
" noremap <down> <nop>
" nnoremap <up> <nop>
" nnoremap <down> <nop>
" vnoremap <up> <nop>
" vnoremap <down> <nop>
" inoremap <up> <nop>
" inoremap <down> <nop>

" delete trailing spaces
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>
" retab!!
nmap <LEADER><TAB> :call Preserve("retab")<CR>
nmap <F9> :call FormatHTML()<CR>
nmap _= :call Preserve("normal gg=G")<CR>

" no autodindent with F2
set pastetoggle=<F2>

" gidt to insert timestamp
nmap gidt a<C-R>=strftime("%Y-%m-%d %H:%M")<CR><Esc>
imap gidt <C-R>=strftime("%Y-%m-%d %H:%M")<CR>

" gid to insert date
nmap gid a<C-R>=strftime("%Y-%m-%d")<CR><Esc>
imap gid <C-R>=strftime("%Y-%m-%d")<CR>

"Fast filetype switching
map <leader>1 :set ft=php<CR>
map <leader>2 :set ft=html<CR>

" Folding on and off
nnoremap <leader>f :set nofoldenable<CR>
nnoremap <leader>fo :set foldenable<CR>
