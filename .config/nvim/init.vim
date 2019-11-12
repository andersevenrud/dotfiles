"
" Anders Evenrud neovim config
"
" Base Dependencies:
" - ripgrep (rg)
" - vim-plug
" - python3
" - node + npm + yarn
" - typescript npm package
" - rust + cargo
" - make
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:vim_jsx_pretty_colorful_config = 1

let g:markdown_syntax_conceal = 0
let g:markdown_composer_autostart = 0

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_ctrlp = 0
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeDecorateFileNodes = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_cursor_line_number_background = 1
let g:nord_underline = 1

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

let g:NERDTreeWinPos = 'left'
let g:vue_disable_pre_processors=1
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.blade.php"
let g:node_host_prog = '/home/anders/.nvm/versions/node/v8.11.2/bin/neovim-node-host'

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified', 'vistanearest' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'vistanearest': 'NearestMethodOrFunction',
      \   'gitbranch': 'fugitive#head'
      \ }
 \}

let g:coc_global_extensions = [
      \ 'coc-rls',
      \ 'coc-html',
      \ 'coc-highlight',
      \ 'coc-snippets',
      \ 'coc-json',
      \ 'coc-css',
      \ 'coc-eslint',
      \ 'coc-yaml',
      \ 'coc-phpls',
      \ 'coc-vetur',
      \ 'coc-stylelint',
      \ 'coc-tsserver',
      \ 'coc-lists',
      \ 'coc-pairs',
      \ 'coc-tslint',
      \ 'coc-import-cost',
      \ 'coc-xml',
      \ 'coc-template',
      \ 'coc-inline-jest',
      \ 'coc-docker',
      \ 'coc-sh',
      \ 'coc-lua',
      \ 'coc-styled-components',
      \ 'coc-flutter'
      \ ]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.config/nvim')
  " Improved Syntax
  Plug 'tmux-plugins/vim-tmux'
  Plug 'jwalton512/vim-blade'
  Plug 'lumiliet/vim-twig'
  Plug 'elzr/vim-json'
  Plug 'StanAngeloff/php.vim'
  Plug 'pangloss/vim-javascript'
  Plug 'MaxMEllon/vim-jsx-pretty' " replaces 'chemzqm/vim-jsx-improve' 'pangloss/vim-javascript'
  Plug 'posva/vim-vue'
  Plug 'nikvdp/ejs-syntax'
  Plug 'tbastos/vim-lua'
  Plug 'HerringtonDarkholme/yats.vim'
  "Old coc was typescript-styled-plugin
  "Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

  " Language Support
  Plug 'joonty/vdebug'
  Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
  Plug 'liuchengxu/vista.vim'
  Plug 'jungomi/vim-mdnquery'
  Plug 'alvan/vim-closetag'
  Plug 'euclio/vim-markdown-composer', { 'do': 'cargo build --release' }

  " UI
  Plug 'itchyny/lightline.vim'
  Plug 'mhinz/vim-signify'
  Plug 'tpope/vim-fugitive'
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'Shougo/denite.nvim'
  Plug 'wincent/terminus'
  Plug 'arcticicestudio/nord-vim'
  Plug 'ryanoasis/vim-devicons'
call plug#end()

call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!node_modules'])
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--no-heading'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

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
set updatetime=444
set fileformats=unix,dos,mac
set encoding=utf-8
syntax sync minlines=333

" Misc runtime stuff
set tags=./tags,tags;/
set path+=**
set noshowmode

" Don't blink terminal or make that annoying sound
set vb t_vb="
set noerrorbells
set visualbell

" General visuals
set nowrap
set hlsearch
set showmatch
set ruler
set number
set numberwidth=5
set foldlevel=20
set signcolumn=yes
set cmdheight=2

" Default indentation
set ai
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Fixes truecolor support
"set t_Co=256
"let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

" Theme (set last)
colorscheme nord

" Highlight trailing whitespaces and unwanted characters
highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
set list listchars=nbsp:¬,tab:>-,trail:.,precedes:<,extends:>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Denite
nnoremap <C-p> :<C-u>Denite file/rec buffer<CR>

" Copy paste via system clipboard
inoremap <C-S-v> <ESC>"+pa
vnoremap <C-S-c> "+y

" Make escape behave like C-c
inoremap <c-c> <ESC>

" Tab manipulation
nnoremap <silent> <Leader>+ :exe "vertical resize +10"<CR>
nnoremap <silent> <Leader>- :exe "vertical resize -10"<CR>

" NERDTree
map <Leader>f :NERDTreeToggle<CR>
map <Leader><S-f> :NERDTreeFind<CR>

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetypes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" General
set wildignore+=*.o,*.a,*.class,*.mo,*.la,*.so,*.obj
set wildignore+=*.*.swp,.tern-port,*.tmp
set wildignore+=*.jpg,*.jpeg,*.png,*.xpm,*.gif,*.bmp
set wildignore+=.git,.svn,CVS
set wildignore+=*/vendor/**
set wildignore+=*/node_modules/**,*/bower_components/**
set wildignore+=*/DS_Store/**

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Tmux window titles
autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window %")
autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))
autocmd VimLeave * call system("tmux rename-window bash")
autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
set title

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Vista trigger
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Run jest for current project
command! -nargs=0 Jest :call  CocAction('runCommand', 'jest.projectTest')

" Run jest for current file
command! -nargs=0 JestCurrent :call  CocAction('runCommand', 'jest.fileTest', ['%'])

" Run jest for current test
nnoremap <leader>te :call CocAction('runCommand', 'jest.singleTest')<CR>

" Init jest in current cwd, require global jest command exists
command! JestInit :call CocAction('runCommand', 'jest.init')

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

