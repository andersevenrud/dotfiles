--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

require('packer').startup(function(use)

    -- Dependencies
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use 'ryanoasis/vim-devicons'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            local config = require'config'
            require'nvim-treesitter.configs'.setup(config.treesitter)
        end
    }

    -- UI
    use 'romgrk/nvim-treesitter-context'
    use 'dominikduda/vim_current_word' -- vimscript
    use 'haringsrob/nvim_context_vt'
    use {
        'norcalli/nvim-colorizer.lua',
        config = function()
            local config = require'config'
            require'colorizer'.setup(config.colorizer.filetypes, config.colorizer.options)
        end
    }
    use {
        'hoob3rt/lualine.nvim',
        config = function()
            local config = require'config'
            require'lualine'.setup(config.lualine)
        end
    }
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            local config = require'config'
            require'gitsigns'.setup(config.gitsigns)
        end
    }
    use {
        'maaslalani/nordbuddy',
        requires = { 'tjdevries/colorbuddy.nvim' },
        config = function()
            local config = require'config'
            for k, v in pairs(config.nordbuddy) do vim.g['nord_' .. k] = v end
            require'colorbuddy'.colorscheme(config.colorbuddy.colorscheme)
        end
    }

    -- Editing
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use 'tpope/vim-commentary'
    use 'windwp/nvim-ts-autotag'
    use 'matze/vim-move'
    use {
        'windwp/nvim-autopairs',
        config = function()
            local config = require'config'
            require'nvim-autopairs'.setup(config.npairs)
        end
    }

    -- Navigation
    use 'simrat39/symbols-outline.nvim'
    use {
        'folke/todo-comments.nvim',
        config = function()
            require'todo-comments'.setup{}
        end
    }
    use {
        'nacro90/numb.nvim',
        config = function()
            local config = require'config'
            require'numb'.setup(config.numb)
        end
    }
    use {
        'nvim-telescope/telescope.nvim',
        config = function()
            local config = require'config'
            local telescope = require'telescope'
            telescope.setup(config.telescope.setup)
            for _, v in ipairs(config.telescope.extensions) do telescope.load_extension(v) end
        end
    }
    use {
        'kyazdani42/nvim-tree.lua';
        config = function()
            local config = require'config'
            for k, v in pairs(config.nvim_tree) do vim.g['nvim_tree_' .. k] = v end
        end
    }

    -- Debugging
    use 'mfussenegger/nvim-dap'
    use {
        'theHamsta/nvim-dap-virtual-text',
        config = function()
            local config = require'config'
            vim.g.dap_virtual_text = config.dap_virtual_text.enabled
        end
    }
    use {
        'Pocco81/DAPInstall.nvim',
        config = function()
            local config = require'config'
            local dap = require'dap-install'
            dap.setup(config.dap_install.setup)
            for _, v in ipairs(config.dap_install.install) do dap.config(v, {}) end
        end
    }

    -- Utilities
    use 'wincent/terminus'
    use 'editorconfig/editorconfig-vim'
    use {
        'sindrets/diffview.nvim',
        config = function()
            require'diffview'.setup{}
        end
    }
    use {
        'TimUntersberger/neogit',
        config = function()
            local config = require'config'
            require'neogit'.setup(config.neogit)
        end
    }
    use {
        'euclio/vim-markdown-composer',
        run = 'cargo build --release',
        config = function()
            local config = require'config'
            for k, v in pairs(config.markdown_composer) do vim.g['markdown_composer_' .. k] = v end
        end
    }

    -- Autocomplete
    use {
        'hrsh7th/nvim-compe',
        config = function()
            local config = require'config'
            require'compe'.setup(config.compe)

            -- Add basic snippet support when language server does not
            -- Replaces: https://github.com/windwp/nvim-autopairs#using-nvim-compe
            -- Ref: https://github.com/hrsh7th/nvim-compe/issues/302
            local Helper = require'compe.helper'
            Helper.convert_lsp_orig = Helper.convert_lsp
            Helper.convert_lsp = function(args)
                local response = args.response or {}
                local items = response.items or response
                for _, item in ipairs(items) do
                    if item.insertText == nil and (item.kind == 2 or item.kind == 3 or item.kind == 4) then
                        item.insertText = item.label .. '(${1})'
                        item.insertTextFormat = 2
                    end
                end
                return Helper.convert_lsp_orig(args)
            end

            -- Run vsnip on startup and not on demand to reduce latency on initial completion
            vim.api.nvim_exec('autocmd FileType * call vsnip#get_complete_items(bufnr())', false)
        end
    }
    use {
        'tzachar/compe-tabnine',
        run = './install.sh',
        requires = { 'hrsh7th/nvim-compe' }
    }
    use {
        'andersevenrud/compe-tmux',
        requires = { 'hrsh7th/nvim-compe' },
        disabled = true
    }
    use 'hrsh7th/vim-vsnip'
    use 'rafamadriz/friendly-snippets'

    -- LSP
    use 'alexaandru/nvim-lspupdate'
    use 'jose-elias-alvarez/nvim-lsp-ts-utils'
    use 'arkav/lualine-lsp-progress'
    use {
        'neovim/nvim-lspconfig',
        config = function()
            local config = require'config'
            local nvim_lsp = require'lspconfig'
            for k, v in pairs(config.lsp_config) do
                local options = vim.tbl_extend('keep', {
                    capabilities = config.lsp.capabilities
                }, v)

                nvim_lsp[k].setup(options)
            end
        end
    }
    use {
        'onsails/lspkind-nvim',
        config = function()
            require'lspkind'.init{}
        end
    }
    use {
        'folke/trouble.nvim',
        config = function()
            require'trouble'.setup{}
        end
    }
    use {
        'ray-x/lsp_signature.nvim',
        config = function()
            local config = require'config'
            require'lsp_signature'.on_attach(config.lsp_signature)
        end
    }
    use {
        'creativenull/diagnosticls-nvim',
        config = function()
            local diagnosticls = require'diagnostics'
            require'diagnosticls-nvim'.init{}
            require'diagnosticls-nvim'.setup(diagnosticls)
        end
    }
    use {
        'akinsho/flutter-tools.nvim',
        config = function()
            local config = require'config'
            require'flutter-tools'.setup(config.flutter_tools)
        end
    }
end)
