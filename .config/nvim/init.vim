"
" NeoVim 0.5+ Configuration by
" Anders Evenrud <andersevenrud@gmail.com>
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.config/nvim/plugins')
  " Dependencies
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'tjdevries/colorbuddy.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'ryanoasis/vim-devicons'

  " UI
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'romgrk/nvim-treesitter-context'
  Plug 'dominikduda/vim_current_word' " vimscript
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'maaslalani/nordbuddy'
  Plug 'haringsrob/nvim_context_vt'

  " Editing
  Plug 'windwp/nvim-autopairs'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  Plug 'tpope/vim-commentary'
  Plug 'windwp/nvim-ts-autotag'
  Plug 'matze/vim-move'

  " Navigation
  Plug 'nacro90/numb.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'simrat39/symbols-outline.nvim'
  Plug 'folke/todo-comments.nvim'

  " Debugging
  Plug 'mfussenegger/nvim-dap'
  Plug 'theHamsta/nvim-dap-virtual-text'
  Plug 'Pocco81/DAPInstall.nvim'

  " Utilities
  Plug 'wincent/terminus'
  Plug 'TimUntersberger/neogit'
  Plug 'sindrets/diffview.nvim'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'euclio/vim-markdown-composer', { 'do': 'cargo build --release' }

  " Autocomplete
  Plug 'hrsh7th/nvim-compe'
  Plug 'tzachar/compe-tabnine', { 'do': './install.sh' }
  Plug 'andersevenrud/compe-tmux'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'rafamadriz/friendly-snippets'

  " LSP
  Plug 'neovim/nvim-lspconfig'
  Plug 'alexaandru/nvim-lspupdate'
  Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
  Plug 'folke/trouble.nvim'
  Plug 'akinsho/flutter-tools.nvim'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'creativenull/diagnosticls-nvim'
  Plug 'arkav/lualine-lsp-progress'
  Plug 'onsails/lspkind-nvim'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" general settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set shortmess+=c                        " Silence warnings
set completeopt=menuone,noselect        " Always open popup and user selection
set backspace=indent,eol,start          " Backspace context
set pumheight=30                        " Limit height of autocomplete popup
set signcolumn=yes                      " Use sign column in gutter to prevent jumping
set numberwidth=4                       " Wide number gutter
set number rnu                          " Show number gutter as relative number
set termguicolors                       " Respect terminal colors
set hidden                              " Allow jumping between unsaved buffers
set smartcase                           " Smart case handling in search
set ignorecase                          " Ignore casing in highlights etc
set incsearch                           " Incremental searches
set noshowmode                          " No show mode
set noerrorbells                        " No error bells
set visualbell                          " No visual bells
set nowrap                              " No text wrapping
set hlsearch                            " Highlight searches
set showmatch                           " Show matching brackets, etc
set ruler                               " Show ruler in status
set cursorline                          " Show cursor line hightlight
set title                               " Use window title
set ai                                  " Use autoindent
set expandtab                           " Spaces, not tabs
set tabstop=2                           " Default spacing
set softtabstop=2                       " Default spacing
set shiftwidth=2                        " Default spacing
set foldlevel=999                       " Expand all folds by default
set updatetime=1000                     " Lower CursorHold update times
set foldmethod=expr                     " Use custom folding
set foldexpr=nvim_treesitter#foldexpr() " Use tree-sitter for folding

" Show symbols for certain special characters
set list listchars=nbsp:¬,tab:·\ ,trail:.,precedes:<,extends:>

" Ignore these files and directories
set wildignore+=*.o,*.a,*.class,*.mo,*.la,*.so,*.obj
set wildignore+=*.swp,.tern-port,*.tmp
set wildignore+=*.jpg,*.jpeg,*.png,*.xpm,*.gif,*.bmp,*.ico
set wildignore+=.git,.svn,CVS
set wildignore+=DS_Store

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" auto commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Custom filetypes
autocmd BufNewFile,BufRead *.heml set ft=html
autocmd BufNewFile,BufRead *.rasi set ft=css
autocmd BufNewFile,BufRead *.tl set ft=teal

" Language rules
autocmd FileType lua    setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype php    setlocal tabstop=4 softtabstop=4 shiftwidth=4

" Highlight group for trailing whitespaces
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" Tmux window titles
if exists('$TMUX')
  autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window %")
  autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))
  autocmd VimLeave * call system("tmux rename-window bash")
  autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" theme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

highlight link LspDiagnosticsUnderlineError DiffDelete
highlight link LspDiagnosticsUnderlineWarning DiffChange
highlight link GitSignsCurrentLineBlame tscomment
highlight link ExtraWhitespace RedrawDebugRecompose
highlight LineNr ctermbg=NONE guibg=NONE
highlight CurrentWordTwins gui=underline
highlight CurrentWord gui=underline

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Make C-c behave like ESC
inoremap <C-c> <ESC>

" Destroy buffer with C-w on leader
nnoremap <leader><C-w> :bd<CR>

" Don't increment search on '*'
nnoremap * *``
nnoremap * :keepjumps normal! mi*`i<CR>

" Horizontal split resizing
nnoremap <leader>+ <C-W>4>
nnoremap <leader>- <C-W>4<

" Vertical split resizing
nnoremap <leader>? <C-W>4+
nnoremap <leader>_ <C-W>4-

" Rebind vertical arrows to scrolling
nnoremap <Up> <C-y>
nnoremap <Down> <C-e>

" Rebind horizontal arrows to tab switching
nnoremap <Right> gt
nnoremap <Left>  gT

" Close all buffers
nnoremap <leader>bd <cmd>%bd<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> gD        <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gd        <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K         <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi        <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr        <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <C-k>     <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <space>wa <cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
nnoremap <silent> <space>wr <cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
nnoremap <silent> <space>wl <cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
nnoremap <silent> <space>D  <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <space>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <space>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <space>f  <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <space>q  <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <silent> <space>e  <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> [d        <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d        <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Telescope keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>ff <cmd>lua require'telescope.builtin'.find_files()<cr>
nnoremap <leader>fg <cmd>lua require'telescope.builtin'.live_grep()<cr>
nnoremap <leader>fb <cmd>lua require'telescope.builtin'.buffers()<cr>
nnoremap <leader>fh <cmd>lua require'telescope.builtin'.help_tags()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neogit keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent><leader>go :Neogit<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Tree keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>fr :NvimTreeRefresh<CR>
nnoremap <leader>fo :NvimTreeFindFile<CR>
nnoremap <leader>ft :NvimTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Compe keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim snip keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" trouble keybindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent><leader>fd <cmd>LspTroubleToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" symbols-outline keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent><leader>fs :SymbolsOutline<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nvim-lsp-ts-utils keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup tsbindings
  autocmd! tsbindings
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer><silent><leader>lo :TSLspOrganize<CR>
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer><silent><leader>lf :TSLspFixCurrent<CR>
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer><silent><leader>lr :TSLspRenameFile<CR>
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer><silent><leader>li :TSLspImportAll<CR>
augroup end

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lua stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

lua require('neovim')
