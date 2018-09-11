"
" Anders Evenrud neovim config
"
" Base Dependencies:
" - vim-plug
" - python3
"
" Plugin Binaries:
" - node/npm
" - php/composer
" - rust/cargo
" - c/make
"
" Integration Binaries:
" - flow-language-server
" - css-language-server
" - typescript
" - tern
" - php
" - node
" - eslint
" - stylelint
"
" Integration Usage:
" - LC/Deoplete: .tern-project - Javascript
" - LC/Deoplete: .flowconfig - Javascript/Flow
" - LC/Deoplete: tsconfig.json - Javascript/Typescript
" - LC/Deoplete: composer.json - PHP
" - Ale: .eslintrc - Javascript Linting
" - Ale: .stylelint - CSS Linting
"
" TODO: See if some set-ers can be removed because of defaults.
" TODO: See if some of syntax plugins can be removed (outdated/nvim bundled).
" TODO: Settle on one method of JS integration support. Needs more testing.
" TODO: Check back on PHP LanguageClient integration instead of phpactor.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ale_sign_column_always = 1
let g:ale_php_phpcs_standard = 'PSR2'
let g:ale_fixers = {
\   'javascript.jsx': ['eslint'],
\   'javascript': ['eslint'],
\   'css': ['stylelint'],
\}

let g:markdown_syntax_conceal = 0
let g:markdown_composer_autostart = 0

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_refresh_always = 1
let g:deoplete#max_abbr_width = 0
let g:deoplete#max_menu_width = 0
let g:deoplete#sources#ternjs#case_insensitive = 1
let g:deoplete#sources#ternjs#docs = 1
let g:deoplete#sources#ternjs#types = 1

let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_root_markers = ['composer.json', 'package.json', '.eslintrc', '.csslintrc']
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_match_func = { 'match': 'cpsm#CtrlPMatch' }
let g:ctrlp_working_path_mode = 'w'

let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'javascript': ['flow-language-server', '--stdio'],
    \ 'javascript.jsx': ['flow-language-server', '--stdio'],
    \ 'css': ['css-languageserver', '--stdio'],
    \ 'less': ['css-languageserver', '--stdio'],
    \ 'sass': ['css-languageserver', '--stdio'],
    \ 'scss': ['css-languageserver', '--stdio']
    \ }
"    \ 'javascript': ['javascript-typescript-stdio'],
"    \ 'javascript.jsx': ['javascript-typescript-stdio'],

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

let g:mta_use_matchparen_group = 1
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'blade' : 1,
    \ 'ejs' : 1,
    \ 'vue' : 1,
    \ 'javascript.jsx' : 1,
    \}

let g:Powerline_symbols = 'fancy'
let g:NERDTreeWinPos = 'left'
let g:vue_disable_pre_processors=1
let g:echodoc_enable_at_startup = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:ackprg = 'rg --vimgrep --no-heading'
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.blade.php"
let g:node_host_prog = '/home/anders/.nvm/versions/node/v8.11.2/bin/neovim-node-host'
let g:neosnippet#enable_completed_snippet = 1
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

  " Syntax
  Plug 'othree/html5.vim'
  Plug 'jwalton512/vim-blade'
  Plug 'lumiliet/vim-twig'
  Plug 'elzr/vim-json'
  Plug 'hail2u/vim-css3-syntax'
  Plug 'groenewege/vim-less'
  Plug 'ekalinin/Dockerfile.vim'
  Plug 'StanAngeloff/php.vim'
  Plug 'pangloss/vim-javascript'
  Plug 'posva/vim-vue'
  Plug 'nikvdp/ejs-syntax'
  Plug 'tbastos/vim-lua'

  " Language Support etc
  Plug 'joonty/vdebug'
  Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
  Plug 'phpactor/phpactor',  {'do': 'composer install'}
  Plug 'moll/vim-node'
  Plug 'alvan/vim-php-manual'
  Plug 'docteurklein/vim-symfony'
  Plug 'Quramy/tsuquyomi', { 'do': 'npm install -g typescript' }
  Plug 'w0rp/ale'

  " Autocomplete
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'kristijanhusak/deoplete-phpactor'
  Plug 'Shougo/echodoc.vim'
  Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
  Plug 'mhartington/deoplete-typescript'

  " Editing
  Plug 'jiangmiao/auto-pairs'
  Plug 'alvan/vim-closetag'
  Plug 'tpope/vim-surround'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'euclio/vim-markdown-composer', { 'do': 'cargo build --release' }
  Plug 'Shougo/neosnippet'
  Plug 'Shougo/neosnippet-snippets'
  Plug 'Valloric/MatchTagAlways'
  Plug 'RRethy/vim-illuminate'

  " UI and other interfaces
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'bling/vim-airline'
  Plug 'mhinz/vim-signify'
  Plug 'tpope/vim-fugitive'
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'arcticicestudio/nord-vim'
  Plug 'ryanoasis/vim-devicons'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" General behavior
set nocompatible
set lazyredraw
set wildmenu
set wildmode=longest,list,full
set laststatus=2
set history=500
set hidden
set smartcase
set ignorecase
set incsearch
set exrc
set secure
set backspace=indent,eol,start
set completeopt=longest,menuone
set shortmess+=c

" Misc runtime stuff
set tags=./tags,tags;/
set runtimepath^=~/.config/nvim/ctrlp.vim
set path+=**
set noshowmode

" Don't blink terminal or make that annoying sound
set vb t_vb="
set noerrorbells
set visualbell

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" General
set nowrap
set hlsearch
set showmatch
set ruler
set number
set numberwidth=5
set foldlevel=20
set signcolumn=yes

" Theme
set t_Co=256
set termguicolors
colorscheme nord

" Highlight trailing whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/

" Highlight unwanted characters
set list listchars=nbsp:¬,tab:>-,trail:.,precedes:<,extends:>

" Highlight current line
set cursorline
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine ctermbg=234

" Tmux window titles
autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window %")
autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))
autocmd VimLeave * call system("tmux rename-window bash")
autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
set title

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Copy paste via system clipboard
inoremap <C-S-v> <ESC>"+pa
vnoremap <C-S-c> "+y

" Make escape behave like C-c
inoremap <c-c> <ESC>

" Tabbing in autocompletion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Don't make newline when using enter in autocomplete
imap <expr><CR> pumvisible() ? deoplete#mappings#close_popup() : "\<CR>\<Plug>AutoPairsReturn"

" Tab manipulation
nnoremap <C-Delete> :tabclose<CR>
nnoremap <C-End> :tabonly<CR>
nnoremap <silent> <Leader>+ :exe "vertical resize +10"<CR>
nnoremap <silent> <Leader>- :exe "vertical resize -10"<CR>

" Neosnippet parameter completion
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" Ale Linting error jumping
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" NERDTree
map <Leader>f :NERDTreeToggle<CR>
map <Leader><S-f> :NERDTreeFind<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Teh Codez
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" General
set fileformats=unix,dos,mac
set encoding=utf-8
set wildignore+=*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.swp,.tern-port
set wildignore+=.git,.svn,CVS
set wildignore+=*/node_modules/**,*/bower_components/**,*/vendor/**,*/DS_Store/**

" Default tabbing (spaces)
set ai
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Extensions
autocmd BufNewFile,BufRead *.jsx set syntax=javascript.jsx
autocmd BufNewFile,BufRead *.mjs set syntax=javascript
autocmd BufNewFile,BufRead *.ejs set syntax=javascript
autocmd BufNewFile,BufRead *.inc set syntax=php
autocmd BufNewFile,BufRead *.blade.php set ft=blade
autocmd BufNewFile,BufRead *.heml set ft=html

" Code Formatting options
autocmd FileType lua setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype php setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType markdown let g:indentLine_enabled=0
autocmd FileType vue syntax sync fromstart
autocmd FileType nerdtree setlocal nolist conceallevel=3 concealcursor=niv

" Auto insert pairs on autocomplete
call deoplete#custom#source('_', 'converters', ['converter_auto_paren'])

" Deoplete source ordering
call deoplete#custom#source('ternjs', 'rank', 10000)
call deoplete#custom#source('LanguageClient', 'rank', 100)
