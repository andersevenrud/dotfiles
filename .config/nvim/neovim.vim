"
" NeoVim 0.5+ Configuration by
" Anders Evenrud <andersevenrud@gmail.com>
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.config/nvim/plugins')
  " Libraries
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'wincent/terminus'
  Plug 'alexaandru/nvim-lspupdate'

  " Syntax (for non tree-sitter)
  Plug 'sheerun/vim-polyglot'

  " UI
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'ryanoasis/vim-devicons'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'christianchiarulli/nvcode-color-schemes.vim'
  Plug 'lukas-reineke/indent-blankline.nvim', { 'branch': 'lua' }
  Plug 'glepnir/lspsaga.nvim'
  Plug 'onsails/lspkind-nvim'
  Plug 'yamatsum/nvim-cursorline'
  Plug 'romgrk/barbar.nvim'

  " Editing
  Plug 'Raimondi/delimitMate' " windwp/nvim-autopairs ?
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  Plug 'tpope/vim-commentary'
  Plug 'windwp/nvim-ts-autotag'

  " Navigation
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'kyazdani42/nvim-tree.lua'
  "Plug 'nvim-telescope/telescope-media-files.nvim'

  " Utilities
  Plug 'euclio/vim-markdown-composer', { 'do': 'cargo build --release' }
  Plug 'TimUntersberger/neogit'
  Plug 'mfussenegger/nvim-dap'

  " Languages support
  Plug 'hrsh7th/nvim-compe', { 'commit': 'c2f59c052eb3d5de4953a851739fcd27728d8e3d' }
  Plug 'tzachar/compe-tabnine', { 'do': './install.sh' }
  Plug 'andersevenrud/compe-tmux'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
  Plug 'kosayoda/nvim-lightbulb'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim theme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

colorscheme nord

hi BufferCurrentMod guifg=#eceff4 ctermfg=255 guibg=#2e3440 ctermbg=237 gui=bold cterm=bold

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim general settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set shortmess+=c                  " Silence warnings
set completeopt=menuone,noselect  " Always open popup and user selection
set backspace=indent,eol,start    " Backspace context
set signcolumn=yes                " Use sign column in gutter to prevent jumping
set numberwidth=4                 " Wide number gutter
set number                        " Show number gutter
set termguicolors                 " Respect terminal colors
set hidden                        " Allow jumping between unsaved buffers
set smartcase                     " Smart case handling in search
set ignorecase                    " Ignore casing in highlights etc
set incsearch                     " Incremental searches
set noshowmode                    " No show mode
set noerrorbells                  " No error bells
set visualbell                    " No visual bells
set nowrap                        " No text wrapping
set hlsearch                      " Highlight searches
set showmatch                     " Show matching brackets, etc
set ruler                         " Show ruler in status
set title                         " Use windot title
set ai                            " Use autoindent
set expandtab                     " Spaces, not tabs
set tabstop=2                     " Default spacing
set softtabstop=2                 " Default spacing
set shiftwidth=2                  " Default spacing
set foldlevel=999                 " Expand all folds by default
set updatetime=300                " Lower CursorHold update times

" Ignore these files and directories
set wildignore+=*.o,*.a,*.class,*.mo,*.la,*.so,*.obj
set wildignore+=*.*.swp,.tern-port,*.tmp
set wildignore+=*.jpg,*.jpeg,*.png,*.xpm,*.gif,*.bmp
set wildignore+=.git,.svn,CVS
set wildignore+=*/DS_Store/**

" Highlight trailing characters
highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
set list listchars=nbsp:¬,tab:>-,trail:.,precedes:<,extends:>

" Custom filetypes
autocmd BufNewFile,BufRead *.heml set ft=html

" Language rules
autocmd FileType lua    setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype php    setlocal tabstop=4 softtabstop=4 shiftwidth=4

" Tmux window titles
if exists('$TMUX')
  autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window %")
  autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))
  autocmd VimLeave * call system("tmux rename-window bash")
  autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin: nvcode-color-schemes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:nvcode_termcolors=256

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin: indentLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:indent_blankline_show_trailing_blankline_indent = v:false
let g:indent_blankline_char = '┊'
let g:indent_blankline_buftype_exclude = ['help', 'terminal']
let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_show_first_indent_level = v:false

autocmd FileType markdown let g:indent_blankline_enabled=v:false

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin: Compe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Skip these sources entirely
let g:loaded_compe_spell = v:true
let g:loaded_compe_nvim_lua = v:true
let g:loaded_compe_calc = v:true
let g:loaded_compe_tags = v:true
let g:loaded_compe_emoji = v:true

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin: Treesitter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin: lightbulb
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin: markdown composer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:markdown_composer_autostart = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin: barbar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let bufferline = get(g:, 'bufferline', {})
let bufferline.tabpages = v:false
let bufferline.auto_hide = v:true
let bufferline.animation = v:false
