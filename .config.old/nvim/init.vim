"
" Anders Evenrud <andersevenrud@gmail.com> (neo)vim config
"
" Vim Dependencies:
" - python3
" - vim-plug
"
" Language Dependencies:
" - nodejs + npm
" - php + composer
" - rust + cargo
" - ripgrep (rg)
" - make
" - watchman
"
" LSP Binaries:
" - https://github.com/Maxattax97/coc-ccls
"
" Node dependencies (npm install -g):
" - typescript
" - vue-language-server
" - bash-language-server
"
" Notes: See 'composer.json' and 'coc-settings.json'
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
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:vue_pre_processors = 'detect_on_enter'

let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.blade.php"

let g:vim_jsx_pretty_colorful_config = 1
let g:vim_jsx_pretty_highlight_close_tag = 1

let g:markdown_syntax_conceal = 0
let g:markdown_composer_autostart = 0

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_cursor_line_number_background = 1
let g:nord_underline = 1

let g:indentLine_color_term = 0
let g:indentLine_bgcolor_term = 'NONE'
let g:indentLine_color_gui = '#3b4252'
let g:indentLine_bgcolor_gui = 'NONE'
let g:indentLine_concealcursor = 0

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

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'paste', 'readonly', 'filename', 'modified' ],
      \     [ 'cocstatus', 'diagnostics' ]
      \   ],
      \   'right': [
      \     [ 'filetype', 'fileencoding', 'lineinfo', 'percent' ],
      \     [ 'gitbranch', 'vistanearest' ]
      \   ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'vistanearest': 'NearestMethodOrFunction',
      \   'gitbranch': 'fugitive#head'
      \ }
 \}


let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'
let g:coc_snippet_next = '<tab>'
let g:coc_node_path = trim(system('which node'))
let g:coc_global_extensions = [
      \ 'coc-python',
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
      \ 'coc-docker',
      \ 'coc-sh',
      \ 'coc-lua',
      \ 'coc-styled-components',
      \ 'coc-flutter',
      \ 'coc-omnisharp',
      \ 'coc-markdownlint',
      \ 'coc-cssmodules',
      \ 'coc-yank',
      \ 'coc-style-helper',
      \ 'coc-explorer',
      \ 'coc-tabnine',
      \ 'coc-grammarly'
      \ ]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.config/nvim')
  " Language Support
  Plug 'sheerun/vim-polyglot'
  Plug 'puremourning/vimspector'
  Plug 'liuchengxu/vista.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " Editing
  Plug 'alvan/vim-closetag'
  Plug 'euclio/vim-markdown-composer', {'do': 'cargo build --release'}

  " UI
  Plug 'itchyny/lightline.vim'
  Plug 'mhinz/vim-signify'
  Plug 'tpope/vim-fugitive'
  Plug 'wincent/terminus'
  Plug 'arcticicestudio/nord-vim'
  Plug 'ryanoasis/vim-devicons'
  Plug 'Yggdroot/indentLine'
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
set updatetime=300
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
set title

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

" Ignores
set wildignore+=*.o,*.a,*.class,*.mo,*.la,*.so,*.obj
set wildignore+=*.*.swp,.tern-port,*.tmp
set wildignore+=*.jpg,*.jpeg,*.png,*.xpm,*.gif,*.bmp
set wildignore+=.git,.svn,CVS
set wildignore+=*/vendor/**
set wildignore+=*/node_modules/**,*/bower_components/**
set wildignore+=*/DS_Store/**

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Coc extensions
nnoremap <F35> :CocList buffers<CR>
nnoremap <F36> :CocList files<CR>
map <F12> :CocCommand explorer<CR>

" Copy paste via system clipboard
inoremap <C-S-v> <ESC>"+pa
vnoremap <C-S-c> "+y

" Make escape behave like C-c
inoremap <c-c> <ESC>

" Tab manipulation
nnoremap <silent> <Leader>+ :exe "vertical resize +10"<CR>
nnoremap <silent> <Leader>- :exe "vertical resize -10"<CR>


" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>


" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
" Note coc#float#scroll works on neovim >= 0.4.0 or vim >= 8.2.0750
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" NeoVim-only mapping for visual mode scroll
" Useful on signatureHelp after jump placeholder of snippet expansion
if has('nvim')
  vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
  vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Auto commands for files and buffers
augroup mygroup
  autocmd!

  " Custom syntax types
  autocmd BufNewFile,BufRead *.heml set ft=html

  " Formatting per filetype
  autocmd FileType lua setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype php setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType markdown let g:indentLine_enabled=0
  autocmd FileType vue syntax sync fromstart

  " Tmux: Window titles
  autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window %")
  autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))
  autocmd VimLeave * call system("tmux rename-window bash")
  autocmd BufEnter * let &titlestring = ' ' . expand("%:t")

  " Vista: Show nearest function or method
  autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

  " Coc: Use autocmd to force lightline update.
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

  " Coc: Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Coc: Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')

  " Coc: Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
