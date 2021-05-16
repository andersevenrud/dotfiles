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
  Plug 'tjdevries/colorbuddy.nvim'

  " UI
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'ryanoasis/vim-devicons'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'onsails/lspkind-nvim'
  Plug 'akinsho/nvim-bufferline.lua'
  Plug 'romgrk/nvim-treesitter-context'
  Plug 'norcalli/nvim-colorizer.lua'

  " Themes
  Plug 'maaslalani/nordbuddy'

  " Editing
  Plug 'windwp/nvim-autopairs'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  Plug 'tpope/vim-commentary'
  Plug 'windwp/nvim-ts-autotag'
  Plug 'matze/vim-move'

  " Navigation
  Plug 'yamatsum/nvim-cursorline'
  Plug 'nacro90/numb.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'nvim-telescope/telescope-media-files.nvim'
  Plug 'simrat39/symbols-outline.nvim'
  Plug 'folke/todo-comments.nvim'

  " Utilities
  Plug 'mfussenegger/nvim-dap'
  Plug 'theHamsta/nvim-dap-virtual-text'
  Plug 'kdheepak/lazygit.nvim'
  Plug 'euclio/vim-markdown-composer', { 'do': 'cargo build --release' }
  Plug 'editorconfig/editorconfig-vim'
  Plug 'creativenull/diagnosticls-nvim'

  " LSP
  Plug 'glepnir/lspsaga.nvim'
  Plug 'hrsh7th/nvim-compe'
  Plug 'tzachar/compe-tabnine', { 'do': './install.sh' }
  Plug 'andersevenrud/compe-tmux'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
  Plug 'folke/lsp-trouble.nvim'
  Plug 'arkav/lualine-lsp-progress'
  Plug 'akinsho/flutter-tools.nvim'
  Plug 'haringsrob/nvim_context_vt'
  Plug 'rafamadriz/friendly-snippets'
call plug#end()

source ~/.config/nvim/neovim.vim
luafile ~/.config/nvim/neovim.lua
source ~/.config/nvim/keybindings.vim
