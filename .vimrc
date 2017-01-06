syntax on
filetype plugin on
filetype indent on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
set laststatus=2
set history=500

" Search behaviour
set smartcase
set ignorecase
set incsearch

" Make per-project .vimrc available
set exrc
set secure

" Make backspace a more flexible
set backspace=indent,eol,start

" Autocompletion
set completeopt=longest,menuone
highlight Pmenu guibg=brown gui=bold

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" X11
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set mousehide
set antialias
set guifont=Monaco\ 7.5
set guioptions-=T
set guioptions+=c
set linespace=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visuals
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Theme
set t_Co=256
colorscheme desert256
set background=dark

" Only visual bell
set vb t_vb="
set noerrorbells
set visualbell

" General user interface
set hlsearch
set showmatch
set ruler
set number

" Other interface stuff
set numberwidth=5
set tw=1000
set list listchars=nbsp:¬,tab:>-,trail:.,precedes:<,extends:>
set foldlevel=20

" When airline not present
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" <Leader>+ <Leader>- for resize pane
nnoremap <silent> <Leader>+ :exe "vertical resize +10"<CR>
nnoremap <silent> <Leader>- :exe "vertical resize -10"<CR>

" <Leader>f for nerdtree
" <Leader><Shift-f> for nerdtree
map <Leader>f :NERDTreeToggle<CR>
map <Leader><S-f> :NERDTreeFind<CR>

" <TAB> for neocomplete
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" <home> toggles between start of line and start of text
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

" <end> goes to end of screen before end of line
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
autocmd Filetype php setlocal cino=:0g0(0,W4 tabstop=4 softtabstop=4 shiftwidth=4 expandtab omnifunc=phpcomplete#CompletePHP
autocmd FileType javascript setlocal omnifunc=tern#Complete
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
autocmd FileType html,xhtml setlocal ofu=htmlcomplete#CompleteTags
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
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.blade.php"

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
  Plugin 'VundleVim/Vundle.vim'

  " Libraries
  Plugin 'tpope/vim-obsession'
  Plugin 'MarcWeber/vim-addon-mw-utils'
  Plugin 'tomtom/tlib_vim'
  Plugin 'tmux-plugins/vim-tmux'
  Plugin 'embear/vim-localvimrc'
  "Plugin 'Shougo/vimproc.vim'
  Plugin 'mileszs/ack.vim'
  Plugin 'ternjs/tern_for_vim'

  " Syntax
  Plugin 'othree/html5.vim'
  Plugin 'othree/csscomplete.vim'
  Plugin 'jwalton512/vim-blade'
  Plugin 'lumiliet/vim-twig'
  Plugin 'elzr/vim-json'
  Plugin 'gavocanov/vim-js-indent'
  Plugin 'hail2u/vim-css3-syntax'
  Plugin 'plasticboy/vim-markdown'
  Plugin 'groenewege/vim-less'
  Plugin 'ekalinin/Dockerfile.vim'
  Plugin 'StanAngeloff/php.vim'

  " Editing
  "Plugin 'Townk/vim-autoclose'
  Plugin 'jiangmiao/auto-pairs'
  Plugin 'alvan/vim-closetag'
  Plugin 'tpope/vim-surround'
  Plugin 'nathanaelkane/vim-indent-guides'
  Plugin 'ctrlpvim/ctrlp.vim'
  Plugin 'scrooloose/syntastic'
  Plugin 'garbas/vim-snipmate'
  "Plugin 'm2mdas/phpcomplete-extended'
  Plugin 'shawncplus/phpcomplete.vim'
  Plugin 'Shougo/neocomplete.vim'
  "Plugin 'Shougo/unite.vim'
  Plugin 'tpope/vim-commentary'

  " UI and other interfaces
  Plugin 'bling/vim-airline'
  Plugin 'mhinz/vim-signify'
  Plugin 'scrooloose/nerdtree'
  Plugin 'tpope/vim-fugitive'
  Plugin 'Xuyuanp/nerdtree-git-plugin'
  Plugin 'joonty/vdebug'

call vundle#end()

execute pathogen#infect()
