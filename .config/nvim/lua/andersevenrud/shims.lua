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
    ['maaslalani/nordbuddy'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'nordbuddy'.colorscheme(n.config.nordbuddy)
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
    ['kyazdani42/nvim-tree.lua'] = {
        config = function()
            -- FIXME: This will probably break in the future because this plugin is moving
            --        settings to setup from global vars.
            local n = require'andersevenrud.neovim'
            n.apply_globals(n.config.nvim_tree.global, 'nvim_tree_')
            require'nvim-tree'.setup(n.config.nvim_tree.options)
        end
    },
    ['theHamsta/nvim-dap-virtual-text'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            vim.g.dap_virtual_text = n.config.dap_virtual_text.enabled
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
    ['andersevenrud/compe-tmux'] = {
        branch = 'cmp'
    },
    ['hrsh7th/nvim-cmp'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            local cmp = require'cmp'
            cmp.setup(n.config.cmp(cmp))
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
                ts_utils.setup{}
                ts_utils.setup_client(client)
            end)
        end
    },
    ['neovim/nvim-lspconfig'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            local nvim_lsp = require'lspconfig'
            for k, v in pairs(n.config.lsp.servers) do
                local options = vim.tbl_extend('keep', {
                    capabilities = n.config.lsp.capabilities,
                    flags = n.config.lsp.flags,
                    on_attach = function(...)
                        n.run_on_attach(k, ...)
                        n.run_on_attach('*', ...)
                    end
                }, v)

                nvim_lsp[k].setup(options)
            end
        end
    },
    ['alexaandru/nvim-lspupdate'] = {
        run = 'make lua'
    },
    ['onsails/lspkind-nvim'] = {
        config = function()
            require'lspkind'.init{}
        end
    },
    ['jose-elias-alvarez/null-ls.nvim'] = {
        requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        config = function()
            local n = require'andersevenrud.neovim'
            local nlsh = require'null-ls.helpers'
            local nlsu = require'null-ls.utils'
            local nls = require'null-ls'
            local sources = n.load_null_ls_sources(nls, nlsh, nlsu, n.config.nullls)
            nls.config({ sources = sources })
            require('lspconfig')['null-ls'].setup{}
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
    ['rmagatti/goto-preview'] = {
        config = function()
            require'goto-preview'.setup{}
        end
    }
}
