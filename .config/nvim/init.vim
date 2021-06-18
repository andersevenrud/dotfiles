"
" NeoVim 0.5+ Configuration by
" Anders Evenrud <andersevenrud@gmail.com>
"

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
  Plug 'yamatsum/nvim-cursorline'
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
  Plug 'nvim-telescope/telescope-media-files.nvim'
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

source ~/.config/nvim/neovim.vim
luafile ~/.config/nvim/neovim.lua
source ~/.config/nvim/keybindings.vim
