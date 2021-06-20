--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local M = {}
local config = require'config'
local neovim = require'neovim'

local hoc = function(fn) fn(config, neovim) end

M.load = function()
    local startup = function(use)
        -- Dependencies
        use 'wbthomason/packer.nvim'
        use 'nvim-lua/popup.nvim'
        use 'nvim-lua/plenary.nvim'
        use 'kyazdani42/nvim-web-devicons'
        use 'ryanoasis/vim-devicons'
        use {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
            config = hoc(function(config)
                require'nvim-treesitter.configs'.setup(config.treesitter)
            end)
        }

        -- UI
        use 'romgrk/nvim-treesitter-context'
        use 'dominikduda/vim_current_word' -- vimscript
        use 'haringsrob/nvim_context_vt'
        use {
            'norcalli/nvim-colorizer.lua',
            config = hoc(function(config)
                require'colorizer'.setup(config.colorizer.filetypes, config.colorizer.options)
            end)
        }
        use {
            'hoob3rt/lualine.nvim',
            config = hoc(function(config)
                require'lualine'.setup(config.lualine)
            end)
        }
        use {
            'lewis6991/gitsigns.nvim',
            config = hoc(function(config)
                require'gitsigns'.setup(config.gitsigns)
            end)
        }
        use {
            'maaslalani/nordbuddy',
            requires = { 'tjdevries/colorbuddy.nvim' },
            config = hoc(function(config, neovim)
                neovim.apply_globals(config.nordbuddy, 'nord_')
                require'colorbuddy'.colorscheme(config.colorbuddy.colorscheme)
            end)
        }

        -- Editing
        use 'JoosepAlviste/nvim-ts-context-commentstring'
        use 'tpope/vim-commentary'
        use 'windwp/nvim-ts-autotag'
        use 'matze/vim-move'
        use {
            'windwp/nvim-autopairs',
            config = hoc(function(config)
                require'nvim-autopairs'.setup(config.npairs)
            end)
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
            config = hoc(function(config)
                require'numb'.setup(config.numb)
            end)
        }
        use {
            'nvim-telescope/telescope.nvim',
            config = hoc(function(config)
                local telescope = require'telescope'
                telescope.setup(config.telescope.setup)
                for _, v in ipairs(config.telescope.extensions) do telescope.load_extension(v) end
            end)
        }
        use {
            'kyazdani42/nvim-tree.lua';
            config = hoc(function(config, neovim)
                neovim.apply_globals(config.nvim_tree, 'nvim_tree_')
            end)
        }

        -- Debugging
        use 'mfussenegger/nvim-dap'
        use {
            'theHamsta/nvim-dap-virtual-text',
            config = hoc(function(config)
                vim.g.dap_virtual_text = config.dap_virtual_text.enabled
            end)
        }
        use {
            'Pocco81/DAPInstall.nvim',
            config = hoc(function(config)
                local dap = require'dap-install'
                dap.setup(config.dap_install.setup)
                for _, v in ipairs(config.dap_install.install) do dap.config(v, {}) end
            end)
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
            config = hoc(function(config)
                require'neogit'.setup(config.neogit)
            end)
        }
        use {
            'euclio/vim-markdown-composer',
            run = 'cargo build --release',
            config = hoc(function(config, neovim)
                neovim.apply_globals(config.markdown_composer, 'markdown_composer_')
            end)
        }

        -- Autocomplete
        use {
            {
                'hrsh7th/nvim-compe',
                config = hoc(function(config)
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
                end),
            },
            {
                'tzachar/compe-tabnine',
                run = './install.sh'
            },
            {
                'andersevenrud/compe-tmux',
            },
            {
                'hrsh7th/vim-vsnip'
            },
            {
                'rafamadriz/friendly-snippets'
            }
        }

        -- LSP
        use 'alexaandru/nvim-lspupdate'
        use 'arkav/lualine-lsp-progress'
        use {
            'jose-elias-alvarez/nvim-lsp-ts-utils',
            config = hoc(function(config, neovim)
                neovim.add_on_attach('tsserver', function(client)
                    local ts_utils = require'nvim-lsp-ts-utils'
                    ts_utils.setup{}
                    ts_utils.setup_client(client)
                end)
            end)
        }
        use {
            'neovim/nvim-lspconfig',
            config = hoc(function(config, neovim)
                local nvim_lsp = require'lspconfig'
                for k, v in pairs(config.lsp.servers) do
                    local options = vim.tbl_extend('keep', {
                        capabilities = config.lsp.capabilities,
                        on_attach = function(...)
                            neovim.run_on_attach(k, ...)
                        end
                    }, v)
                    nvim_lsp[k].setup(options)
                end
            end)
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
            config = hoc(function(config)
                require'lsp_signature'.on_attach(config.lsp_signature)
            end)
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
            config = hoc(function(config)
                require'flutter-tools'.setup(config.flutter_tools)
            end)
        }
    end

    require('packer').startup({
        startup,
        config = config.packer
    })
end

return M
