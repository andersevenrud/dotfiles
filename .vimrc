"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype plugin on
filetype indent on
syntax on

" Filetypes and encoding
set fileformats=unix,dos,mac
set encoding=utf-8
set wildignore=.svn,CVS,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

" General behaviour
set nowrap
set nocompatible
set lazyredraw
set wildmenu
set wildmode=longest,list,full

" Search behaviour
set smartcase
set ignorecase
set hlsearch
set incsearch

" Make per-project .vimrc available
set exrc
set secure

" Make backspace a more flexible
set backspace=indent,eol,start

" Autocompletion
set completeopt+=longest,menuone
highlight Pmenu guibg=brown gui=bold

" Disable sounds
set vb t_vb="
set noerrorbells
set visualbell

" Tabbing, Default to 2 spaces as tabs
set ai
set cino=:0g0(0,W2
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Misc runtime stuff
set tags=./tags,tags;/
set runtimepath^=~/.vim/bundle/ctrlp.vim
set path+=**

" General user interface
set showmatch
set ruler
set number

" Other interface stuff
set numberwidth=5
set linespace=0
set history=500
set tw=1000
set foldlevel=20
set list listchars=nbsp:¬,tab:>-,trail:.,precedes:<,extends:>
set laststatus=2

" X Settings
set mousehide
set antialias
set guifont=Monaco\ 7.5
set guioptions-=T
set guioptions+=c

" Themes and colors
set t_Co=256
colorscheme desert256
set background=dark

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Change PgUp/PgDown to scroll
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Highlight trailing whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/

" Tmux compability
autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window %")
autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))
autocmd VimLeave * call system("tmux rename-window bash")
autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
set title

" Filetypes
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType javascript setlocal omnifunc=tern#Complete
"autocmd Filetype php setlocal cino=:0g0(0,W4 tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd Filetype php setlocal cino=:0g0(0,W4 tabstop=4 softtabstop=4 shiftwidth=4 expandtab omnifunc=phpcomplete_extended#CompletePHP
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
autocmd FileType html,xhtml setlocal ofu=htmlcomplete#CompleteTags
"autocmd Filetype *.blade.php setlocal cino=:0g0(0,W2 tabstop=2 softtabstop=2 shiftwidth=2 expandtab omnifunc=htmlcomplete#CompleteTags
autocmd BufNewFile,BufRead *.blade.php set ft=blade

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:syntastic_javascript_checkers = ['jshint', 'jscs']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_php_checkers = ['php']
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:javascript_plugin_jsdoc = 1
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_root_markers = ['composer.json', 'package.json']
let g:SuperTabDefaultCompletionType = "<C-x><C-o>"

execute pathogen#infect()
