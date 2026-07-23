--
-- NeoVim 0.11+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

return {
    ['nvim-treesitter/nvim-treesitter'] = {
        branch = 'main',
        lazy = false, -- Does not support lazy-loading
        build = ':TSUpdate',
        config = function(n)
            n.setup_treesitter(n.config.treesitter)
        end,
    },
    ['nvim-treesitter/nvim-treesitter-textobjects'] = {
        branch = 'main',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function(n)
            n.setup_treesitter_textobjects(n.config.treesitter_textobjects)
        end,
    },
    ['windwp/nvim-ts-autotag'] = {
        config = function()
            require('nvim-ts-autotag').setup({})
        end,
    },
    ['github/copilot.vim'] = {
        event = 'InsertEnter',
    },
    ['stevearc/vim-arduino'] = {
        ft = { 'arduino' },
    },
    ['catgoose/nvim-colorizer.lua'] = {
        ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue', 'svelte', 'twig', 'lua' },
        config = function(n)
            require('colorizer').setup({
                filetypes = n.config.colorizer.filetypes,
                user_default_options = n.config.colorizer.options,
            })
        end,
    },
    ['nvim-lualine/lualine.nvim'] = {
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function(n)
            require('lualine').setup(n.config.lualine)
        end,
    },
    ['lewis6991/gitsigns.nvim'] = {
        event = { 'BufReadPre', 'BufNewFile' },
        config = function(n)
            require('gitsigns').setup(n.config.gitsigns)
        end,
    },
    ['andersevenrud/nordic.nvim'] = {
        priority = 1000,
        config = function(n)
            require('nordic').colorscheme(n.config.nordic)
        end,
    },
    ['windwp/nvim-autopairs'] = {
        event = 'InsertEnter',
        config = function(n)
            local a = require('nvim-autopairs')
            a.setup(n.config.npairs.options)
        end,
    },
    ['folke/todo-comments.nvim'] = {
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('todo-comments').setup({})
        end,
    },
    ['nacro90/numb.nvim'] = {
        event = 'CmdlineEnter',
        config = function(n)
            require('numb').setup(n.config.numb)
        end,
    },
    ['nvim-telescope/telescope.nvim'] = {
        lazy = true,
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
        config = function(n)
            local telescope = require('telescope')

            telescope.setup(n.config.telescope.setup)

            for _, v in ipairs(n.config.telescope.extensions or {}) do
                telescope.load_extension(v)
            end
        end,
    },
    ['nvim-neo-tree/neo-tree.nvim'] = {
        dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
        config = function(n)
            require('neo-tree').setup(n.config.neo_tree)
        end,
    },
    ['mfussenegger/nvim-dap'] = {
        lazy = true,
        dependencies = { 'theHamsta/nvim-dap-virtual-text' },
        config = function(n)
            n.setup_dap(n.config.dap)
        end,
    },
    ['rcarriga/nvim-dap-ui'] = {
        lazy = true,
        dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
        config = function(n)
            n.setup_dap_ui(n.config.dap_ui)
        end,
    },
    ['theHamsta/nvim-dap-virtual-text'] = {
        lazy = true,
        config = function(n)
            require('nvim-dap-virtual-text').setup(n.config.dap_virtual_text)
        end,
    },
    ['sindrets/diffview.nvim'] = {
        cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh', 'DiffviewFileHistory', 'DiffviewLog' },
        config = function()
            require('diffview').setup({})
        end,
    },
    ['euclio/vim-markdown-composer'] = {
        build = 'cargo build --release',
        ft = { 'markdown' },
        config = function(n)
            n.apply_globals(n.config.markdown_composer, 'markdown_composer_')
        end,
    },
    ['L3MON4D3/LuaSnip'] = {
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
        end,
    },
    ['saghen/blink.cmp'] = {
        -- NOTE: blink.lib is required at module load time, so it has to be an
        -- explicit dependency for the build step below to be able to run
        dependencies = { 'saghen/blink.lib', 'L3MON4D3/LuaSnip', 'rafamadriz/friendly-snippets', 'mgalliou/blink-cmp-tmux' },
        build = function()
            -- NOTE: `pwait` is pcall wrapped and swallows build failures, which
            -- silently leaves the plugin on the slower Lua fuzzy matcher
            local ok, err = require('blink.cmp').build():pwait()
            if not ok then
                error('blink.cmp: native library build failed: ' .. tostring(err))
            end
        end,
        config = function(n)
            require('blink.cmp').setup(n.config.blink)
        end,
    },
    ['neovim/nvim-lspconfig'] = {
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
        config = function(n)
            n.setup_lsp()
        end,
    },
    ['akinsho/flutter-tools.nvim'] = {
        ft = { 'flutter', 'dart' },
        config = function(n)
            require('flutter-tools').setup(n.config.flutter_tools)
        end,
    },
    ['akinsho/toggleterm.nvim'] = {
        branch = 'main',
        cmd = { 'ToggleTerm', 'ToggleTermToggleAll', 'TermExec', 'TermSelect' },
        keys = { '<leader>t' },
        config = function(n)
            require('toggleterm').setup(n.config.nvim_toggleterm)
        end,
    },
    ['sindrets/winshift.nvim'] = {
        cmd = { 'WinShift' },
        config = function(n)
            require('winshift').setup(n.config.winshift)
        end,
    },
    ['haringsrob/nvim_context_vt'] = {
        event = { 'BufReadPost', 'BufNewFile' },
        config = function(n)
            require('nvim_context_vt').setup(n.config.context_vt)
        end,
    },
    ['nvimdev/lspsaga.nvim'] = {
        config = function(n)
            require('lspsaga').setup(n.config.lspsaga)
        end,
    },
    ['folke/snacks.nvim'] = {
        priority = 1000,
        lazy = false,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function(n)
            require('snacks').setup(n.config.snacks)
        end,
    },
    ['folke/noice.nvim'] = {
        dependencies = { 'MunifTanjim/nui.nvim' },
        config = function(n)
            require('noice').setup(n.config.noice)
        end,
    },
    ['nat-418/boole.nvim'] = {
        config = function(n)
            require('boole').setup(n.config.boole)
        end,
    },
    ['NeogitOrg/neogit'] = {
        cmd = { 'Neogit', 'NeogitCommit', 'NeogitLogCurrent', 'NeogitResetState' },
        config = function()
            require('neogit').setup({})
        end,
    },
    ['pmizio/typescript-tools.nvim'] = {
        ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        config = function()
            require('typescript-tools').setup({})
        end,
    },
    ['olimorris/codecompanion.nvim'] = {
        cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions', 'CodeCompanionCmd', 'CodeCompanionToggle' },
        config = function()
            require('codecompanion').setup({})
        end,
    },
}
