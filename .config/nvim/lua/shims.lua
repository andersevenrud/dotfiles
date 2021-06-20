--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

return {
    ['nvim-treesitter/nvim-treesitter'] = {
        run = ':TSUpdate',
        config = function()
            local n = require'neovim'
            require'nvim-treesitter.configs'.setup(n.c.treesitter)
        end
    },
    ['tjdevries/colorbuddy.nvim'] = {
        config = function()
            local n = require'neovim'
            require'colorbuddy'.colorscheme(n.c.colorbuddy.colorscheme)
        end
    },
    ['norcalli/nvim-colorizer.lua'] = {
        config = function()
            local n = require'neovim'
            require'colorizer'.setup(n.c.colorizer.filetypes, n.c.colorizer.options)
        end
    },
    ['hoob3rt/lualine.nvim'] = {
        config = function()
            local n = require'neovim'
            require'lualine'.setup(n.c.lualine)
        end
    },
    ['lewis6991/gitsigns.nvim'] = {
        config = function()
            local n = require'neovim'
            require'gitsigns'.setup(n.c.gitsigns)
        end
    },
    ['maaslalani/nordbuddy'] = {
        config = function()
            local n = require'neovim'
            n.apply_globals(n.c.nordbuddy, 'nord_')
        end
    },
    ['windwp/nvim-autopairs'] = {
        config = function()
            local n = require'neovim'
            require'nvim-autopairs'.setup(n.c.npairs)
        end
    },
    ['folke/todo-comments.nvim'] = {
        config = function()
            require'todo-comments'.setup{}
        end
    },
    ['nacro90/numb.nvim'] = {
        config = function()
            local n = require'neovim'
            require'numb'.setup(n.c.numb)
        end
    },
    ['nvim-telescope/telescope.nvim'] = {
        config = function()
            local n = require'neovim'
            local telescope = require'telescope'
            telescope.setup(n.c.telescope.setup)
            for _, v in ipairs(n.c.telescope.extensions) do telescope.load_extension(v) end
        end
    },
    ['kyazdani42/nvim-tree.lua'] = {
        config = function()
            local n = require'neovim'
            n.apply_globals(n.c.nvim_tree, 'nvim_tree_')
        end
    },
    ['theHamsta/nvim-dap-virtual-text'] = {
        config = function()
            local n = require'neovim'
            vim.g.dap_virtual_text = n.c.dap_virtual_text.enabled
        end
    },
    ['Pocco81/DAPInstall.nvim'] = {
        config = function()
            local n = require'neovim'
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
            local n = require'neovim'
            n.apply_globals(n.c.markdown_composer, 'markdown_composer_')
        end
    },
    ['hrsh7th/nvim-compe'] = {
        config = function()
            local n = require'neovim'
            require'compe'.setup(n.c.compe)

            -- add basic snippet support when language server does not
            -- replaces: https://github.com/windwp/nvim-autopairs#using-nvim-compe
            -- ref: https://github.com/hrsh7th/nvim-compe/issues/302
            local helper = require'compe.helper'
            helper.convert_lsp_orig = helper.convert_lsp
            helper.convert_lsp = function(args)
                local response = args.response or {}
                local items = response.items or response
                for _, item in ipairs(items) do
                    if item.inserttext == nil and (item.kind == 2 or item.kind == 3 or item.kind == 4) then
                        item.inserttext = item.label .. '(${1})'
                        item.inserttextformat = 2
                    end
                end
                return helper.convert_lsp_orig(args)
            end
        end,
    },
    ['tzachar/compe-tabnine'] = {
        run = './install.sh'
    },
    ['jose-elias-alvarez/nvim-lsp-ts-utils'] = {
        config = function()
            local n = require'neovim'
            n.add_on_attach('tsserver', function(client)
                local ts_utils = require'nvim-lsp-ts-utils'
                ts_utils.setup{}
                ts_utils.setup_client(client)
            end)
        end
    },
    ['neovim/nvim-lspconfig'] = {
        config = function()
            local n = require'neovim'
            local nvim_lsp = require'lspconfig'
            for k, v in pairs(n.c.lsp.servers) do
                local options = vim.tbl_extend('keep', {
                    capabilities = n.c.lsp.capabilities,
                    on_attach = function(...)
                        n.run_on_attach(k, ...)
                        n.run_on_attach('*', ...)
                    end
                }, v)
                nvim_lsp[k].setup(options)
            end
        end
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
    ['folke/trouble.nvim'] = {
        config = function()
            require'trouble'.setup{}
        end
    },
    ['ray-x/lsp_signature.nvim'] = {
        config = function()
            local n = require'neovim'
            require'lsp_signature'.on_attach(n.c.lsp_signature)
        end
    },
    ['creativenull/diagnosticls-nvim'] = {
        config = function()
            local diagnosticls = require'diagnostics'
            require'diagnosticls-nvim'.init{}
            require'diagnosticls-nvim'.setup(diagnosticls)
        end
    },
    ['akinsho/flutter-tools.nvim'] = {
        config = function()
            local n = require'neovim'
            require'flutter-tools'.setup(n.c.flutter_tools)
        end
    }
}
