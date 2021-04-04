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
  Plug 'editorconfig/editorconfig-vim'

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

source ~/.config/nvim/neovim.vim
luafile ~/.config/nvim/neovim.lua
source ~/.config/nvim/keybindings.vim
