--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local config = require'config'
local neovim = require'neovim'
local shims = require'shims'

-- Base configuration
neovim.set_options(config.vim.options)
neovim.set_highlights(config.vim.highlights)
neovim.set_aliases(config.vim.aliases)
neovim.set_rules(config.vim.rules)
neovim.set_keymaps(config.vim.keybindings)
neovim.set_lsp_signs(config.lsp.signs)
neovim.set_lsp_options(config.lsp.options)

-- Highlight group for trailing whitespaces
neovim.autocmds_ns('ExtraWhitespaceCommands', {
    { { 'InsertEnter' }, '*', [[match ExtraWhitespace /\s\+\%#\@<!$/]] },
    { { 'InsertLeave' }, '*', [[match ExtraWhitespace /\s\+$/]] }
})

-- Tmux widow titles
if os.getenv('TMUX') then
    neovim.autocmds_ns('TmuxWindowTitlesCommands', {
        { { 'BufReadPost', 'FileReadPost', 'BufNewFile' },  '*', [[call system("tmux rename-window %")]] },
        { { 'BufEnter' }, '*', [[call system("tmux rename-window " . expand("%:t"))]] },
        { { 'VimLeave' }, '*', [[call system("tmux rename-window bash")]] },
        { { 'BufEnter' }, '*', [[let &titlestring = ' ' . expand("%:t")]] }
    })
end

-- Plugins
neovim.packer_load({
    -- Dependencies
    'wbthomason/packer.nvim',
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'kyazdani42/nvim-web-devicons',
    'ryanoasis/vim-devicons',
    'nvim-treesitter/nvim-treesitter',
    'tjdevries/colorbuddy.nvim',

    -- UI
    'romgrk/nvim-treesitter-context',
    'dominikduda/vim_current_word', -- vimscript
    'haringsrob/nvim_context_vt',
    'norcalli/nvim-colorizer.lua',
    'hoob3rt/lualine.nvim',
    'arkav/lualine-lsp-progress',
    'lewis6991/gitsigns.nvim',
    'maaslalani/nordbuddy',

    -- Editing
    'JoosepAlviste/nvim-ts-context-commentstring',
    'tpope/vim-commentary',
    'windwp/nvim-ts-autotag',
    'matze/vim-move',
    'windwp/nvim-autopairs',

    -- Navigation
    'simrat39/symbols-outline.nvim',
    'folke/todo-comments.nvim',
    'nacro90/numb.nvim',
    'nvim-telescope/telescope.nvim',
    'kyazdani42/nvim-tree.lua',

    -- Debugging
    'mfussenegger/nvim-dap',
    'theHamsta/nvim-dap-virtual-text',
    'Pocco81/DAPInstall.nvim',

    -- Utilities
    'wincent/terminus',
    'editorconfig/editorconfig-vim',
    'sindrets/diffview.nvim',
    'TimUntersberger/neogit',
    'euclio/vim-markdown-composer',

    -- Autocomplete
    'hrsh7th/nvim-compe',
    'tzachar/compe-tabnine',
    'andersevenrud/compe-tmux',
    'hrsh7th/vim-vsnip',
    'rafamadriz/friendly-snippets',

    -- LSP
    'jose-elias-alvarez/nvim-lsp-ts-utils',
    'neovim/nvim-lspconfig',
    'alexaandru/nvim-lspupdate',
    'onsails/lspkind-nvim',
    'folke/trouble.nvim',
    'ray-x/lsp_signature.nvim',
    'creativenull/diagnosticls-nvim',
    'akinsho/flutter-tools.nvim',
}, config, shims)
