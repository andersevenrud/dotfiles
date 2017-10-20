"
" c-y = echodoc
"
"
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
set hidden

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
"set completeopt=longest,menuone
"highlight Pmenu guibg=brown gui=bold
set shortmess+=c

" Tabbing, Default to 2 spaces as tabs
set ai
set cino=:0g0(0,W2
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Misc runtime stuff
set tags=./tags,tags;/
set runtimepath^=~/.config/nvim/ctrlp.vim
set path+=**
set noshowmode

" For conceal markers.
"if has('conceal')
"  set conceallevel=2 concealcursor=niv
"endif

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

" Esc triggers C-c
inoremap <c-c> <ESC>

" <Leader>+ <Leader>- for resize pane
nnoremap <silent> <Leader>+ :exe "vertical resize +10"<CR>
nnoremap <silent> <Leader>- :exe "vertical resize -10"<CR>

" <Leader>f for nerdtree
" <Leader><Shift-f> for nerdtree
map <Leader>f :NERDTreeToggle<CR>
map <Leader><S-f> :NERDTreeFind<CR>

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

" LS
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" Tab-ing for popup
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Neosnippet
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" Ale
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

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
autocmd FileType lua setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype php setlocal cino=:0g0(0,W4 tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
autocmd FileType html,xhtml setlocal ofu=htmlcomplete#CompleteTags
autocmd BufNewFile,BufRead *.blade.php set ft=blade

autocmd FileType markdown let g:indentLine_enabled=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:markdown_syntax_conceal = 0
"let g:markdown_composer_open_browser = 0
let g:markdown_composer_autostart = 0
"let g:markdown_composer_browser = 'firefox'
let g:echodoc_enable_at_startup = 1
"let g:syntastic_javascript_checkers = ['eslint']
"let g:syntastic_php_checkers = ['php']
let g:ale_sign_column_always = 1
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'css': ['stylelint'],
\   'php': ['php -l']
\}

let g:javascript_plugin_jsdoc = 1
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_root_markers = ['composer.json', 'package.json']
let g:SuperTabDefaultCompletionType = "<C-x><C-o>"
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.blade.php"
let g:phpcd_disable_modifier = 0
let g:neosnippet#enable_completed_snippet = 1
let g:tern_request_timeout = 1
let g:tern_request_timeout = 6000
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#tss#javascript_support = 1
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'javascript': ['flow-language-server', '--stdio'],
    \ 'javascript.jsx': ['flow-language-server', '--stdio'],
    \ }

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

set statusline=%{LinterStatus()}

call plug#begin('~/.config/nvim')

  " Libraries
  Plug 'tpope/vim-obsession'
  Plug 'MarcWeber/vim-addon-mw-utils'
  Plug 'tomtom/tlib_vim'
  Plug 'tmux-plugins/vim-tmux'
  Plug 'embear/vim-localvimrc'
  Plug 'mileszs/ack.vim'
  Plug 'Shougo/vimproc.vim', { 'do': 'make' }

  " Syntax
  Plug 'othree/html5.vim'
  Plug 'othree/csscomplete.vim'
  Plug 'jwalton512/vim-blade'
  Plug 'lumiliet/vim-twig'
  Plug 'elzr/vim-json'
  Plug 'gavocanov/vim-js-indent'
  Plug 'hail2u/vim-css3-syntax'
  "Plug 'plasticboy/vim-markdown'
  Plug 'groenewege/vim-less'
  Plug 'ekalinin/Dockerfile.vim'
  Plug 'StanAngeloff/php.vim'
  Plug 'othree/yajs.vim'
  Plug 'posva/vim-vue'
  Plug 'nikvdp/ejs-syntax'

  " Editing
  "Plug 'Townk/vim-autoclose'
  Plug 'jiangmiao/auto-pairs'
  Plug 'alvan/vim-closetag'
  Plug 'tpope/vim-surround'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'ctrlpvim/ctrlp.vim'
  "Plug 'scrooloose/syntastic'
  Plug 'w0rp/ale'
  Plug 'garbas/vim-snipmate'
  Plug 'tpope/vim-commentary'
  Plug 'docteurklein/vim-symfony'
  Plug 'yuttie/comfortable-motion.vim'
  Plug 'moll/vim-node'
  Plug 'othree/jspc.vim'
  Plug 'honza/vim-snippets'
  Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

  " UI and other interfaces
  Plug 'bling/vim-airline'
  Plug 'mhinz/vim-signify'
  Plug 'scrooloose/nerdtree'
  Plug 'tpope/vim-fugitive'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'joonty/vdebug'

  " LanguageServer stuff
  Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
  Plug 'junegunn/fzf'
  Plug 'Shougo/denite.nvim'
  Plug 'roxma/nvim-completion-manager'
  Plug 'phpactor/phpactor' ,  {'do': 'composer install'}
  Plug 'roxma/ncm-phpactor'
  Plug 'roxma/ncm-flow'
  Plug 'carlitux/deoplete-ternjs'
  Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
  Plug 'roxma/nvim-cm-tern',  {'do': 'npm install'}


  Plug 'Shougo/echodoc.vim'
  Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}
  Plug 'Shougo/neosnippet'
  Plug 'Shougo/neosnippet-snippets'
  Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer install' }

call plug#end()

