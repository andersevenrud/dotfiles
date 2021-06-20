--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local config = require'config'
local neovim = require'neovim'

local hoc = function(fn) fn(config, neovim) end

return {
    ['nvim-treesitter/nvim-treesitter'] = {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = hoc(function(c)
            require'nvim-treesitter.configs'.setup(c.treesitter)
        end)
    },
    ['tjdevries/colorbuddy.nvim'] = {
        'tjdevries/colorbuddy.nvim',
        config = hoc(function(c)
            require'colorbuddy'.colorscheme(c.colorbuddy.colorscheme)
        end)
    },
    ['norcalli/nvim-colorizer.lua'] = {
        'norcalli/nvim-colorizer.lua',
        config = hoc(function(c)
            require'colorizer'.setup(c.colorizer.filetypes, c.colorizer.options)
        end)
    },
    ['hoob3rt/lualine.nvim'] = {
        'hoob3rt/lualine.nvim',
        config = hoc(function(c)
            require'lualine'.setup(c.lualine)
        end)
    },
    ['lewis6991/gitsigns.nvim'] = {
        'lewis6991/gitsigns.nvim',
        config = hoc(function(c)
            require'gitsigns'.setup(c.gitsigns)
        end)
    },
    ['maaslalani/nordbuddy'] = {
        'maaslalani/nordbuddy',
        config = hoc(function(c, n)
            n.apply_globals(c.nordbuddy, 'nord_')
        end)
    },
    ['windwp/nvim-autopairs'] = {
        'windwp/nvim-autopairs',
        config = hoc(function(c)
            require'nvim-autopairs'.setup(c.npairs)
        end)
    },
    ['folke/todo-comments.nvim'] = {
        'folke/todo-comments.nvim',
        config = function()
            require'todo-comments'.setup{}
        end

    },
    ['nacro90/numb.nvim'] = {
        'nacro90/numb.nvim',
        config = hoc(function(c)
            require'numb'.setup(c.numb)
        end)
    },
    ['nvim-telescope/telescope.nvim'] = {
        'nvim-telescope/telescope.nvim',
        config = hoc(function(c)
            local telescope = require'telescope'
            telescope.setup(c.telescope.setup)
            for _, v in ipairs(c.telescope.extensions) do telescope.load_extension(v) end
        end)
    },
    ['kyazdani42/nvim-tree.lua'] = {
        'kyazdani42/nvim-tree.lua',
        config = hoc(function(c, n)
            n.apply_globals(c.nvim_tree, 'nvim_tree_')
        end)
    },
    ['theHamsta/nvim-dap-virtual-text'] = {
        'theHamsta/nvim-dap-virtual-text',
        config = hoc(function(c)
            vim.g.dap_virtual_text = c.dap_virtual_text.enabled
        end)
    },
    ['Pocco81/DAPInstall.nvim'] = {
        'Pocco81/DAPInstall.nvim',
        config = hoc(function(c)
            local dap = require'dap-install'
            dap.setup(c.dap_install.setup)
            for _, v in ipairs(c.dap_install.install) do dap.config(v, {}) end
        end)
    },
    ['sindrets/diffview.nvim'] = {
        'sindrets/diffview.nvim',
        config = function()
            require'diffview'.setup{}
        end
    },
    ['euclio/vim-markdown-composer'] = {
        'euclio/vim-markdown-composer',
        run = 'cargo build --release',
        config = hoc(function(c, n)
            n.apply_globals(c.markdown_composer, 'markdown_composer_')
        end)
    },
    ['hrsh7th/nvim-compe'] = {
        'hrsh7th/nvim-compe',
        config = hoc(function(c)
            require'compe'.setup(c.compe)

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

            -- run vsnip on startup and not on demand to reduce latency on initial completion
            vim.api.nvim_exec('autocmd filetype * call vsnip#get_complete_items(bufnr())', false)
        end),
    },
    ['tzachar/compe-tabnine'] = {
        'tzachar/compe-tabnine',
        run = './install.sh'
    },
    ['jose-elias-alvarez/nvim-lsp-ts-utils'] = {
        'jose-elias-alvarez/nvim-lsp-ts-utils',
        config = hoc(function(c, n)
            n.add_on_attach('tsserver', function(client)
                local ts_utils = require'nvim-lsp-ts-utils'
                ts_utils.setup{}
                ts_utils.setup_client(client)
            end)
        end)
    },
    ['neovim/nvim-lspconfig'] = {
        'neovim/nvim-lspconfig',
        config = hoc(function(c, n)
            local nvim_lsp = require'lspconfig'
            for k, v in pairs(c.lsp.servers) do
                local options = vim.tbl_extend('keep', {
                    capabilities = c.lsp.capabilities,
                    on_attach = function(...)
                        n.run_on_attach(k, ...)
                        n.run_on_attach('*', ...)
                    end
                }, v)
                nvim_lsp[k].setup(options)
            end
        end)
    },
    ['onsails/lspkind-nvim'] = {
        'onsails/lspkind-nvim',
        config = function()
            require'lspkind'.init{}
        end
    },
    ['folke/trouble.nvim'] = {
        'folke/trouble.nvim',
        config = function()
            require'trouble'.setup{}
        end
    },
    ['ray-x/lsp_signature.nvim'] = {
        'ray-x/lsp_signature.nvim',
        config = hoc(function(c)
            require'lsp_signature'.on_attach(c.lsp_signature)
        end)
    },
    ['creativenull/diagnosticls-nvim'] = {
        'creativenull/diagnosticls-nvim',
        config = function()
            local diagnosticls = require'diagnostics'
            require'diagnosticls-nvim'.init{}
            require'diagnosticls-nvim'.setup(diagnosticls)
        end
    },
    ['akinsho/flutter-tools.nvim'] = {
        'akinsho/flutter-tools.nvim',
        config = hoc(function(c)
            require'flutter-tools'.setup(c.flutter_tools)
        end)
    }
}
