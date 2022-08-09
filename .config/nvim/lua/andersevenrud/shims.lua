--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

return {
    ['nvim-treesitter/nvim-treesitter'] = {
        run = ':TSUpdate',
        config = function()
            local n = require'andersevenrud.neovim'
            require'nvim-treesitter.configs'.setup(n.config.treesitter)
        end
    },
    ['norcalli/nvim-colorizer.lua'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'colorizer'.setup(n.config.colorizer.filetypes, n.config.colorizer.options)
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
        requires = { "MunifTanjim/nui.nvim" },
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
    ['Pocco81/DAPInstall.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            local dap = require'dap-install'
            dap.setup(n.config.dap_install.setup)
            for _, v in ipairs(n.config.dap_install.install) do dap.config(v, {}) end
        end
    },
    ['sindrets/diffview.nvim'] = {
        config = function()
            require'diffview'.setup{}
        end
    },
    ['euclio/vim-markdown-composer'] = {
        run = 'cargo build --release',
        ft = { 'markdown' },
        config = function()
            local n = require'andersevenrud.neovim'
            n.apply_globals(n.config.markdown_composer, 'markdown_composer_')
        end
    },
    ['hrsh7th/nvim-cmp'] = {
        requires = { 'windwp/nvim-autopairs', 'L3MON4D3/LuaSnip', 'onsails/lspkind-nvim' },
        config = function()
            local n = require'andersevenrud.neovim'
            local cmp = require'cmp'
            local apairs = require'nvim-autopairs.completion.cmp'
            local config = n.config.cmp(cmp)

            for k, v in pairs(config.cmdline) do
                cmp.setup.cmdline(k, v)
            end

            cmp.setup(config.cmp)
            cmp.event:on( 'confirm_done', apairs.on_confirm_done({  map_char = { tex = '' } }))
        end
    },
    ['jose-elias-alvarez/nvim-lsp-ts-utils'] = {
        ft = {
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact',
            'vue',
            'svelte',
        },
        config = function()
            local n = require'andersevenrud.neovim'
            n.add_on_attach('tsserver', function(client)
                local ts_utils = require'nvim-lsp-ts-utils'

                -- use null-ls over tsserver formatting
                client.server_capabilities.document_formatting = false
                client.server_capabilities.document_range_formatting = false

                ts_utils.setup(n.config.tsutils)
                ts_utils.setup_client(client)
            end)
        end
    },
    ['neovim/nvim-lspconfig'] = {
        requires = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'ray-x/lsp_signature.nvim'
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
    ['jose-elias-alvarez/null-ls.nvim'] = {
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            local n = require'andersevenrud.neovim'
            local nlsh = require'null-ls.helpers'
            local nlsu = require'null-ls.utils'
            local nls = require'null-ls'
            local sources = n.load_null_ls_sources(nls, nlsh, nlsu, n.config.nullls)
            nls.setup(vim.tbl_extend('keep', {
                sources = sources,
            }, n.config.nullls.options))
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
    ['j-hui/fidget.nvim'] = {
        config = function()
            require'fidget'.setup{}
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
            require('lspsaga').init_lsp_saga({})
        end
    },
}
