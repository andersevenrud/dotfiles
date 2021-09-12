--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

return {
    ['nvim-treesitter/nvim-treesitter'] = {
        run = ':TSUpdate',
        config = function()
            local n = require'andersevenrud.neovim'
            require'nvim-treesitter.configs'.setup(n.c.treesitter)
        end
    },
    ['norcalli/nvim-colorizer.lua'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'colorizer'.setup(n.c.colorizer.filetypes, n.c.colorizer.options)
        end
    },
    ['hoob3rt/lualine.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'lualine'.setup(n.c.lualine)
        end
    },
    ['lewis6991/gitsigns.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'gitsigns'.setup(n.c.gitsigns)
        end
    },
    ['maaslalani/nordbuddy'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'nordbuddy'.colorscheme(n.c.nordbuddy)
        end
    },
    ['windwp/nvim-autopairs'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            local a = require'nvim-autopairs'
            local Rule = require('nvim-autopairs.rule')

            a.setup(n.c.npairs.options)

            for _, v in pairs(n.c.npairs.rules) do
                a.add_rule(Rule(unpack(v)))
            end
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
            require'numb'.setup(n.c.numb)
        end
    },
    ['nvim-telescope/telescope.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            local telescope = require'telescope'
            telescope.setup(n.c.telescope.setup)
            for _, v in ipairs(n.c.telescope.extensions) do telescope.load_extension(v) end
        end
    },
    ['kyazdani42/nvim-tree.lua'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            n.apply_globals(n.c.nvim_tree, 'nvim_tree_')
        end
    },
    ['theHamsta/nvim-dap-virtual-text'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            vim.g.dap_virtual_text = n.c.dap_virtual_text.enabled
        end
    },
    ['Pocco81/DAPInstall.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            local dap = require'dap-install'
            dap.setup(n.c.dap_install.setup)
            for _, v in ipairs(n.c.dap_install.install) do dap.config(v, {}) end
        end
    },
    ['sindrets/diffview.nvim'] = {
        config = function()
            require'diffview'.setup{}
        end
    },
    ['euclio/vim-markdown-composer'] = {
        run = 'cargo build --release',
        config = function()
            local n = require'andersevenrud.neovim'
            n.apply_globals(n.c.markdown_composer, 'markdown_composer_')
        end
    },
    ['andersevenrud/compe-tmux'] = {
        branch = 'cmp'
    },
    ['hrsh7th/nvim-cmp'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            local cmp = require'cmp'
            cmp.setup(n.c.cmp(cmp))
        end
    },
    ['jose-elias-alvarez/nvim-lsp-ts-utils'] = {
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
            for k, v in pairs(n.c.lsp.servers) do
                local options = vim.tbl_extend('keep', {
                    capabilities = n.c.lsp.capabilities,
                    flags = n.c.lsp.flags,
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
    ['hrsh7th/vim-vsnip'] = {
        config = function()
            -- run vsnip on startup and not on demand to reduce latency on initial completion
            vim.api.nvim_exec('autocmd filetype * call vsnip#get_complete_items(bufnr())', false)
        end
    },
    ['onsails/lspkind-nvim'] = {
        config = function()
            require'lspkind'.init{}
        end
    },
    ['creativenull/diagnosticls-configs-nvim'] = {
        config = function()
            local diagnosticls = require'andersevenrud.diagnostics'
            require'diagnosticls-configs'.init{}
            require'diagnosticls-configs'.setup(diagnosticls)
        end
    },
    ['akinsho/flutter-tools.nvim'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'flutter-tools'.setup(n.c.flutter_tools)
        end
    },
    ['akinsho/nvim-toggleterm.lua'] = {
        config = function()
            local n = require'andersevenrud.neovim'
            require'toggleterm'.setup(n.c.nvim_toggleterm)
        end
    },
    ['RishabhRD/nvim-lsputils'] = {
        requires = { 'RishabhRD/popfix' },
        config = function()
            vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
            vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
            vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
            vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
            vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
            vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
            vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
            vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
        end
    },
}
