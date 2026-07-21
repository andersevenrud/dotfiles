--
-- NeoVim 0.11+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

return {
    ['nvim-treesitter/nvim-treesitter'] = {
        branch = 'main',
        lazy = false, -- Does not support lazy-loading
        build = ':TSUpdate',
        config = function()
            local n = require'andersevenrud.neovim'

            vim.filetype.add({ pattern = { [".*%.blade%.php"] = "blade" } })

            n.setup_treesitter(n.config.treesitter)
        end
    },
    ['nvim-treesitter/nvim-treesitter-textobjects'] = {
        branch = 'main',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            local n = require'andersevenrud.neovim'
            n.setup_treesitter_textobjects(n.config.treesitter_textobjects)
        end
    },
    ['windwp/nvim-ts-autotag'] = {
        config = function()
            require'nvim-ts-autotag'.setup{}
        end
    },
    ['catgoose/nvim-colorizer.lua'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'colorizer'.setup({
                filetypes = n.config.colorizer.filetypes,
                user_default_options = n.config.colorizer.options,
            })
        end
    },
    ['hoob3rt/lualine.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'lualine'.setup(n.config.lualine)
        end
    },
    ['lewis6991/gitsigns.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'gitsigns'.setup(n.config.gitsigns)
        end
    },
    ['andersevenrud/nordic.nvim'] = {
        priority = 1000,
        config = function()
            local n = require'andersevenrud.neovim'
            require'nordic'.colorscheme(n.config.nordic)
        end
    },
    ['windwp/nvim-autopairs'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            local a = require'nvim-autopairs'
            a.setup(n.config.npairs.options)
        end
    },
    ['folke/todo-comments.nvim'] = {
        config = function()
            require'todo-comments'.setup{}
        end
    },
    ['nacro90/numb.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'numb'.setup(n.config.numb)
        end
    },
    ['nvim-telescope/telescope.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            local telescope = require'telescope'
            telescope.setup(n.config.telescope.setup)
            for _, v in ipairs(n.config.telescope.extensions) do telescope.load_extension(v) end
        end
    },
    ['nvim-neo-tree/neo-tree.nvim'] = {
        branch = 'v2.x',
        dependencies = { "MunifTanjim/nui.nvim" },
        config = function()
            local n = require'andersevenrud.neovim'
            require'neo-tree'.setup(n.config.neo_tree)
        end
    },
    ['theHamsta/nvim-dap-virtual-text'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'nvim-dap-virtual-text'.setup(n.config.dap_virtual_text)
        end
    },
    ['sindrets/diffview.nvim'] = {
        config = function()
            require'diffview'.setup{}
        end
    },
    ['euclio/vim-markdown-composer'] = {
        build = 'cargo build --release',
        ft = { 'markdown' },
        config = function()
            local n = require'andersevenrud.neovim'
            n.apply_globals(n.config.markdown_composer, 'markdown_composer_')
        end
    },
    ['saghen/blink.cmp'] = {
        dependencies = { 'rafamadriz/friendly-snippets' },
        build = function()
            require('blink.cmp').build():pwait()
        end,
        config = function()
            local n = require'andersevenrud.neovim'
            require('blink.cmp').setup(n.config.blink)
        end
    },
    ['neovim/nvim-lspconfig'] = {
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            --'ray-x/lsp_signature.nvim'
        },
        config = function()
            local n = require'andersevenrud.neovim'
            n.setup_lsp()
        end
    },
    ['onsails/lspkind-nvim'] = {
        config = function()
            require'lspkind'.init{}
        end
    },
    ['akinsho/flutter-tools.nvim'] = {
        ft = { 'flutter', 'dart' },
        config = function()
            local n = require'andersevenrud.neovim'
            require'flutter-tools'.setup(n.config.flutter_tools)
        end
    },
    ['akinsho/nvim-toggleterm.lua'] = {
        branch = 'main',
        config = function()
            local n = require'andersevenrud.neovim'
            require'toggleterm'.setup(n.config.nvim_toggleterm)
        end
    },
    ['sindrets/winshift.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'winshift'.setup(n.config.winshift)
        end
    },
    ['numToStr/Comment.nvim'] = {
        config = function()
            require'Comment'.setup{}
        end
    },
    ['anuvyklack/pretty-fold.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'pretty-fold'.setup(n.config.pretty_fold)
        end
    },
    ['haringsrob/nvim_context_vt'] = {
        config = function()
            require('nvim_context_vt').setup({
                disable_virtual_lines = true
            })
        end
    },
    ['glepnir/lspsaga.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require('lspsaga').setup(n.config.lspsaga)
        end
    },
    ['stevearc/dressing.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'dressing'.setup(n.config.dressing)
        end
    },
    ['folke/noice.nvim'] = {
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
        config = function()
            local n = require'andersevenrud.neovim'
            require'noice'.setup(n.config.noice)
        end
    },
    ['nat-418/boole.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'boole'.setup(n.config.boole)
        end
    },
    ['TimUntersberger/neogit'] = {
        config = function()
            require'neogit'.setup({})
        end
    },
    ['pmizio/typescript-tools.nvim'] = {
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("typescript-tools").setup {}
        end
    },
    ['olimorris/codecompanion.nvim'] = {
        config = function()
            require("codecompanion").setup({})
        end
    },
}
