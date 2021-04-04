"
" NeoVim 0.5+ Configuration by
" Anders Evenrud <andersevenrud@gmail.com>
"

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
" nvcode-color-schemes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:nvcode_termcolors=256

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indentLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:indent_blankline_show_trailing_blankline_indent = v:false
let g:indent_blankline_char = '┊'
let g:indent_blankline_buftype_exclude = ['help', 'terminal']
let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_show_first_indent_level = v:false

autocmd FileType markdown let g:indent_blankline_enabled=v:false

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Compe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Skip these sources entirely
let g:loaded_compe_spell = v:true
let g:loaded_compe_path = v:true
let g:loaded_compe_nvim_lua = v:true
let g:loaded_compe_calc = v:true
let g:loaded_compe_tags = v:true
let g:loaded_compe_emoji = v:true

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treesitter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lightbulb
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Markdown composer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:markdown_composer_autostart = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" barbar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let bufferline = get(g:, 'bufferline', {})
let bufferline.tabpages = v:false
let bufferline.auto_hide = v:true
let bufferline.animation = v:false
