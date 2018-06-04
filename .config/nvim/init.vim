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
set wildignore+=*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.swp,.tern-port
set wildignore+=.git,.svn,CVS
set wildignore+=*/node_modules/**,*/bower_components/**,*/vendor/**,*/DS_Store/**

" General behaviour
set nowrap
set nocompatible
set lazyredraw
set wildmenu
set wildmode=longest,list,full
set laststatus=2
set history=500
"set mouse=n
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
set completeopt=longest,menuone
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visuals
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Theme
set t_Co=256
"colorscheme desert256
"set background=dark

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
set signcolumn=yes

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
nnoremap <C-Delete> :tabclose<CR>
nnoremap <C-End> :tabonly<CR>

" copy/paste X
inoremap <C-S-v> <ESC>"+pa
vnoremap <C-S-c> "+y

" Esc triggers C-c
inoremap <c-c> <ESC>

" <Leader>+ <Leader>- for resize pane
nnoremap <silent> <Leader>+ :exe "vertical resize +10"<CR>
nnoremap <silent> <Leader>- :exe "vertical resize -10"<CR>

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
autocmd BufNewFile,BufRead *.mjs set syntax=javascript
autocmd BufNewFile,BufRead *.ejs set syntax=javascript
autocmd BufNewFile,BufRead *.inc set syntax=php
autocmd FileType lua setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype php setlocal cino=:0g0(0,W4 tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd BufNewFile,BufRead *.blade.php set ft=blade
autocmd BufNewFile,BufRead *.heml set ft=html
autocmd FileType markdown let g:indentLine_enabled=0
autocmd FileType vue syntax sync fromstart

" makes sure nerdtree does not respect my symbol listings
"autocmd FileType nerdtree setlocal nolist conceallevel=3 concealcursor=niv

"autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
"autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
"autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
"autocmd FileType php setlocal omnifunc=phpactor#Complete
"autocmd filetype php set omnifunc=LanguageClient#complete
"autocmd FileType html,xhtml setlocal ofu=htmlcomplete#CompleteTags

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:vue_disable_pre_processors=1

let g:markdown_syntax_conceal = 0
"let g:markdown_composer_open_browser = 0
let g:markdown_composer_autostart = 0
"let g:markdown_composer_browser = 'chromium'
let g:echodoc_enable_at_startup = 1
let g:ale_sign_column_always = 1
let g:ale_php_phpcs_standard = 'PSR2'
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'css': ['stylelint'],
\}
" Handled by phactor
"\   'php': ['php -l', 'phpmd', 'phpcs']

let g:javascript_plugin_jsdoc = 1
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:ackprg = 'rg --vimgrep --no-heading'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_root_markers = ['composer.json', 'package.json', '.eslintrc', '.csslintrc']
"if executable('rg')
"  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
"  let g:ctrlp_use_caching = 0
"endif
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_match_func = { 'match': 'cpsm#CtrlPMatch' }
let g:ctrlp_working_path_mode = 'w'
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.blade.php"
let g:neosnippet#enable_completed_snippet = 1
let g:deoplete#enable_at_startup = 1
let g:LanguageClient_autoStart = 1
    " 'javascript': ['javascript-typescript-stdio'],
    " 'javascript.jsx': ['javascript-typescript-stdio'],
let g:LanguageClient_serverCommands = {
    \ 'javascript': ['flow-language-server', '--stdio'],
    \ 'javascript.jsx': ['flow-language-server', '--stdio'],
    \ 'css': ['css-languageserver', '--stdio'],
    \ 'less': ['css-languageserver', '--stdio'],
    \ 'sass': ['css-languageserver', '--stdio'],
    \ 'scss': ['css-languageserver', '--stdio']
    \ }
let g:tagbar_compact = 1
let g:tagbar_singleclick = 1
let g:tagbar_left = 1
let g:tagbar_vertical = 25
let g:tagbar_width = 60

let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_ctrlp = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeDecorateFileNodes = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
"let g:WebDevIconsNerdTreeAfterGlyphPadding = ''

let g:nord_italic = 1
let g:nord_italic_comments = 1

let g:phpactorPhpBin = 'php'
let g:phpactorBranch = 'master'
let g:phpactorOmniError = v:false

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
  Plug 'xolox/vim-misc'
  Plug 'wincent/terminus'
  Plug 'nixprime/cpsm', { 'do': 'env PY3=OFF ./install.sh' }

  " Syntax and languages
  Plug 'othree/html5.vim'
  Plug 'jwalton512/vim-blade'
  Plug 'lumiliet/vim-twig'
  Plug 'elzr/vim-json'
  Plug 'gavocanov/vim-js-indent'
  Plug 'hail2u/vim-css3-syntax'
  Plug 'groenewege/vim-less'
  Plug 'ekalinin/Dockerfile.vim'
  Plug 'StanAngeloff/php.vim'
  Plug 'othree/yajs.vim'
  Plug 'posva/vim-vue'
  Plug 'nikvdp/ejs-syntax'
  Plug 'moll/vim-node'
  Plug 'alvan/vim-php-manual'
  Plug 'docteurklein/vim-symfony'

  " Language Support etc
  Plug 'joonty/vdebug'
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
  "Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}
  Plug 'phpactor/phpactor',  {'do': 'composer install'}
  "Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }


  " Autocomplete
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'kristijanhusak/deoplete-phpactor'
  Plug 'wokalski/autocomplete-flow'
  "Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
  Plug 'Shougo/echodoc.vim'

  " Editing
  Plug 'jiangmiao/auto-pairs'
  Plug 'alvan/vim-closetag'
  Plug 'tpope/vim-surround'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'w0rp/ale'
  Plug 'euclio/vim-markdown-composer', { 'do': 'cargo build --release' }
  Plug 'Shougo/neosnippet'
  Plug 'Shougo/neosnippet-snippets'

  " UI and other interfaces
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'bling/vim-airline'
  Plug 'mhinz/vim-signify'
  Plug 'tpope/vim-fugitive'
  Plug 'majutsushi/tagbar'

  " This must be loaded lastly
  Plug 'arcticicestudio/nord-vim'
  Plug 'ryanoasis/vim-devicons'

call plug#end()

colorscheme nord
