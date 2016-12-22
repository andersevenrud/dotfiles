
" Enable filetype plugin
filetype plugin on
filetype indent on

" Filetypes and encoding
set fileformats=unix,dos,mac
set encoding=utf-8
set wildignore=.svn,CVS,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

" General behaviour
"set autochdir      " CWD is always same as current file
set ai             " Autoident
"set si             " Smartident
set nowrap         " Do not wrap lines
set nocompatible   " ViM settings instead of Vi
set smartcase      " Smart casing when searching
set ignorecase     " ... or ignore casing
set hlsearch       " Highlight matches
set incsearch      " Modern (wrapping) search
set history=500    " Long undo history
set tw=1000

" make backspace a more flexible
set backspace=indent,eol,start

" Disable sounds
set vb t_vb="
set noerrorbells
set visualbell

" Tabbing, Default to 2 spaces as tabs
set cino=:0g0(0,W2
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Filetype sesific
"au FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
set tags=./tags,tags;/
"set tags=./tags;,tags;
"
autocmd Filetype php setlocal cino=:0g0(0,W4 tabstop=4 softtabstop=4 shiftwidth=4 expandtab omnifunc=phpcomplete_extended#CompletePHP
autocmd Filetype *.blade.php setlocal cino=:0g0(0,W2 tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" Folding
set foldlevel=20

set runtimepath^=~/.vim/bundle/ctrlp.vim
set path+=**
"set omnifunc=syntaxcomplete#Complete

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User interface setings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax on

set showmatch                        " Show matching braces when over one
set ruler                            " Always show current position
set number                           " Always show line-numbers
set numberwidth=5                    " Line-number margin width
set mousehide                        " Do not show mouse while typing
set antialias                        " Pretty fonts
set guifont=Monaco\ 7.5          " Monospaced small font
set guioptions-=T                    " TODO
set guioptions+=c                    " TODO Console messages
set linespace=0                      " Don't insert any extra pixel lines
set lazyredraw                       " Don't redraw while running macros
set wildmenu                         " Wild menu
set wildmode=longest,list,full       " Wild menu options

" Display special characters and helpers
set list
" Show < or > when characters are not displayed on the left or right.
" Also show tabs and trailing spaces.
set list listchars=nbsp:¬,tab:>-,trail:.,precedes:<,extends:>

" Autocompletion
set ofu=syntaxcomplete#Complete
set completeopt+=longest,menuone
highlight Pmenu guibg=brown gui=bold
let g:SuperTabDefaultCompletionType = "<C-x><C-o>"

" Statusline
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
"              | | | | |  |   |      |  |     |    |
"              | | | | |  |   |      |  |     |    + current
"              | | | | |  |   |      |  |     |       column
"              | | | | |  |   |      |  |     +-- current line
"              | | | | |  |   |      |  +-- current % into file
"              | | | | |  |   |      +-- current syntax in
"              | | | | |  |   |          square brackets
"              | | | | |  |   +-- current fileformat
"              | | | | |  +-- number of lines
"              | | | | +-- preview flag in square brackets
"              | | | +-- help flag in square brackets
"              | | +-- readonly flag in square brackets
"              | +-- rodified flag in square brackets
"              +-- full path to file in the buffer

" Highlight trailing whitespaces (+ keybindings below)
highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/

" Theme
set t_Co=256
colorscheme desert256
set background=dark

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
" These actually conflicts with autoclose and omnicomplete
"inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
"inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
"inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" RESIZE with numlock +-/*
if bufwinnr(1)
  map + <C-W>+
  map - <C-W>-
endif

"<home> toggles between start of line and start of text
imap <khome> <home>
nmap <khome> <home>
inoremap <silent> <home> <C-O>:call HHome()<CR>
nnoremap <silent> <home> :call HHome()<CR>
function! HHome()
	let curcol = wincol()
	normal ^
	let newcol = wincol()
	if newcol == curcol
		normal 0
	endif
endfunction

"<end> goes to end of screen before end of line
imap <kend> <end>
nmap <kend> <end>
inoremap <silent> <end> <C-O>:call HEnd()<CR>
nnoremap <silent> <end> :call HEnd()<CR>
function! HEnd()
	let curcol = wincol()
	normal g$
	let newcol = wincol()
	if newcol == curcol
		normal $
	endif
	"http://www.pixelbeat.org/patches/vim-7.0023-eol.diff
	if virtcol(".") == virtcol("$") - 1
		normal $
	endif
endfunction

"Ctrl-{up,down} to scroll. (gvim)
if has("gui_running")
	nmap <C-up> <C-y>
	imap <C-up> <C-o><C-y>
	nmap <C-down> <C-e>
	imap <C-down> <C-o><C-e>
endif

if bufwinnr(1)
  map <kPlus>  <C-W>+
  map <kMinus> <C-W>-
  map <kDivide> <c-w><
  map <kMultiply> <c-w>>
endif

" For highlighting trailing whitespaces
nnoremap <Leader>wn :match ExtraWhitespace /^\s* \s*\<Bar>\s\+$/<CR>
nnoremap <Leader>wf :match<CR>

" space / shift-space scroll in normal mode
noremap <S-space> <C-b>
noremap <space> <C-f>


" TMUX
autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window %")
"autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window %")
autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))
autocmd VimLeave * call system("tmux rename-window bash")
autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
set title

"
" Plugins
"

set laststatus=2
" let g:syntastic_javascript_checkers = ['jshint', 'jscs']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_php_checkers = ['php']
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:javascript_plugin_jsdoc = 1
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_root_markers = ['composer.json', 'package.json']


"imap <C-J> <Plug>snipMateNextOrTrigger
"smap <C-J> <Plug>snipMateNextOrTrigger

execute pathogen#infect()
