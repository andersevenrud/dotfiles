--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local neovim = require'andersevenrud.neovim'
local shims = require'andersevenrud.shims'

local border_style = 'single'
local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'
local secrets = neovim.prequire('andersevenrud.secrets', {
    intelephense = {
        licenceKey = nil
    }
})

local autocommands = {
    ['ExtraWhitespaceCommands'] = {
        { { 'InsertEnter' }, '*', [[match ExtraWhitespace /\s\+\%#\@<!$/]] },
        { { 'InsertLeave' }, '*', [[match ExtraWhitespace /\s\+$/]] }
    },
    ['YankHighlighting'] = {
        { { 'TextYankPost' }, '*', [[lua vim.highlight.on_yank {higroup="IncSearch", timeout=500, on_visual=true}]]}
    },
}

if os.getenv('TMUX') then
    autocommands['TmuxWindowTitlesCommands'] = {
        { { 'BufReadPost', 'FileReadPost', 'BufNewFile' },  '*', [[call system("tmux rename-window %")]] },
        { { 'BufEnter' }, '*', [[call system("tmux rename-window " . expand("%:t"))]] },
        { { 'VimLeave' }, '*', [[call system("tmux rename-window bash")]] },
        { { 'BufEnter' }, '*', [[let &titlestring = ' ' . expand("%:t")]] }
    }
end

local wildignore = {
    '*.o', '*.a', '*.class', '*.mo', '*.la', '*.so', '*.obj',
    '*.swp', '.tern-port', '*.tmp',
    '*.jpg', '*.jpeg', '*.png', '*.xpm', '*.gif', '*.bmp', '*.ico',
    '.git', '.svn', 'CVS',
    'package-lock.json', 'yarn.lock', 'composer.lock',
    'DS_Store'
}

neovim.load({
    vim = {
        autocommands = autocommands,
        options = {
            shortmess = 'filnxtToOFc',                  -- Silence warnings and abbreviate stuff
            completeopt = { 'menuone', 'noselect' },    -- Always open popup and user selection
            backspace = { 'indent', 'eol', 'start' },   -- Backspace context
            pumheight = 30,                             -- Limit height of autocomplete popup
            signcolumn = 'yes',                         -- Use sign column in gutter to prevent jumping
            numberwidth = 4,                            -- Wide number gutter
            number = true,                              -- Show number gutter
            relativenumber = true,                      -- Show number gutter as relative number
            termguicolors = true,                       -- Respect terminal colors
            hidden = true,                              -- Allow jumping between unsaved buffers
            smartcase = true,                           -- Smart case handling in search
            ignorecase = true,                          -- Ignore casing in highlights etc
            incsearch = true,                           -- Incremental searches
            showmode = false,                           -- No show mode
            belloff = 'all',                            -- No error bells
            wrap = false,                               -- No text wrapping
            hlsearch = true,                            -- Highlight searches
            showmatch = true,                           -- Show matching brackets, etc
            ruler = true,                               -- Show ruler in status
            cursorline = true,                          -- Show cursor line hightlight
            title = true,                               -- Use window title
            ai = true,                                  -- Use autoindent
            expandtab = true,                           -- Spaces, not tabs
            tabstop = 2,                                -- Default spacing
            softtabstop = 2,                            -- Default spacing
            shiftwidth = 2,                             -- Default spacing
            foldlevel = 999,                            -- Expand all folds by default
            updatetime = 1000,                          -- Lower CursorHold update times
            foldmethod = 'expr',                        -- Use custom folding
            foldexpr = 'nvim_treesitter#foldexpr()',    -- Use tree-sitter for folding
            wildignore = wildignore,                    -- Ignore these file types
            listchars = {                               -- Show symbols for certain special characters
                nbsp = '¬',
                tab = '·\\',
                trail = '.',
                precedes = '<',
                extends = '>'
            },
        },
        highlights = {
            LspDiagnosticsUnderlineError = { link = 'DiffDelete' },
            LspDiagnosticsUnderlineWarning = { link = 'DiffChange' },
            GitSignsCurrentLineBlame = { link = 'tscomment' },
            ExtraWhitespace = { link = 'RedrawDebugRecompose' },
            LineNr = { ctermbg = 'NONE', guibg = 'NONE' },
            WinShift = { guibg = '#3b4252' }
        },
        aliases = {
            ['*.heml'] = 'html',
            ['*.rasi'] = 'css',
            ['*.tl'] = 'teal'
        },
        rules = {
            lua = { tabstop = 4, softtabstop = 4, shiftwidth = 4 },
            python = { tabstop = 4, softtabstop = 4, shiftwidth = 4 },
            php = { tabstop = 4, softtabstop = 4, shiftwidth = 4 }
        },
        keybindings = {
            -- luasnip
            { 'i', '<Tab>', [[luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>']], { noremap = true, silent = true, expr = true }, 'Jump to next in snippet' },
            { 'i', '<S-Tab>', [[<cmd>lua require'luasnip'.jump(-1)<Cr>]], { noremap = true, silent = true }, 'Jump to prev in snippet' },
            { 's', '<Tab>', [[<cmd>lua require('luasnip').jump(1)<Cr>]], { noremap = true, silent = true }, 'Jump to next in snippet' },
            { 's', '<S-Tab>', [[<cmd>lua require('luasnip').jump(-1)<Cr>]], { noremap = true, silent = true }, 'Jump to prev in snippet' },
            { 'i', '<C-E>', [[luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>']], { silent = true, expr = true }, 'Next snippet choice' },
            { 's', '<C-E>', [[luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>']], { silent = true, expr = true }, 'Next snippet choice' },

            -- LSP
            {
                lsp = '*',
                keybindings = {
                    { 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true }, 'Go to decleration' },
                    { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true }, 'Go to definition' },
                    { 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true }, 'Show documentation' },
                    { 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true }, 'Go to implementation'},
                    { 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true }, 'Go to reference(s)' },
                    { 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true }, 'Show signature help' },
                    { 'i', '<C-A-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true }, 'Show signature help' },
                    { 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { noremap = true, silent = true }, 'Add workspace' },
                    { 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { noremap = true, silent = true }, 'Remove workspace' },
                    { 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', { noremap = true, silent = true }, 'List workspaces' },
                    { 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true }, 'Show type definition' },
                    { 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true }, 'Rename current' },
                    { 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true }, 'Show code actions' },
                    { 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true }, 'Format document' },
                    { 'n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', { noremap = true, silent = true }, 'Set location list item' },
                    { 'n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false, show_header = false })<CR>', { noremap = true, silent = true }, 'Show lined diagnostics' },
                    { 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, silent = true }, 'Go to prev diagnostic' },
                    { 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, silent = true }, 'Go to next diagnostic' },
                }
            },

            -- goto-preview
            {
                lsp = '*',
                keybindings = {
                    { 'n', 'gpd', [[<cmd>lua require('goto-preview').goto_preview_definition()<CR>]], { noremap = true }, 'Go to definition (preview)' },
                    { 'n', 'gpi', [[<cmd>lua require('goto-preview').goto_preview_implementation()<CR>]], { noremap = true }, 'Go to implementation (preview)' },
                    { 'n', 'gP', [[<cmd>lua require('goto-preview').close_all_win()<CR>]], { noremap = true }, 'Close all previews' },
                }
            },

            -- nvim-lsp-ts-utils
            {
                lsp = 'tsserver',
                keybindings = {
                    { 'n', '<space>ri', ':TSLspOrganize<CR>', { silent = true }, 'Organize imports' },
                    { 'n', '<space>cf', ':TSLspFixCurrent<CR>', { silent = true }, 'Fix current' },
                    { 'n', '<space>rwn', ':TSLspRenameFile<CR>', { silent = true }, 'Rename file across workspace' },
                    { 'n', '<space>ia', ':TSLspImportAll<CR>', { silent = true }, 'Import all used definitions' }
                }
            },

            -- Telescope
            { 'n', '<leader>ff', [[<cmd>lua require'telescope.builtin'.find_files()<cr>]], { noremap = true }, 'Fuzzy find files' },
            { 'n', '<leader>fg', [[<cmd>lua require'telescope.builtin'.live_grep()<cr>]], { noremap = true }, 'Fuzzy grep' },
            { 'n', '<leader>fb', [[<cmd>lua require'telescope.builtin'.buffers()<cr>]], { noremap = true }, 'Fuzzy buffers' },
            { 'n', '<leader>fh', [[<cmd>lua require'telescope.builtin'.help_tags()<cr>]], { noremap = true }, 'Fuzzy help' },
            { 'n', '<leader>fd', [[<cmd>lua require'telescope.builtin'.lsp_workspace_diagnostics()<cr>]], { noremap = true }, 'Fuzzy diagnostics' },

            -- neogit
            { 'n', '<leader>go', ':Neogit<CR>', { noremap = true, silent = true }, 'Open neogit' },

            -- nvim-tree
            { 'n', '<leader>fr', ':NvimTreeRefresh<CR>', { noremap = true }, 'Refresh file browser' },
            { 'n', '<leader>fo', ':NvimTreeFindFile<CR>', { noremap = true }, 'Open file browser' },
            { 'n', '<leader>ft', ':NvimTreeToggle<CR>', { noremap = true }, 'Toggle file browser' },

            -- symbols-outline
            { 'n', '<leader>fs', ':SymbolsOutline<CR>', { noremap = true, silent = true }, 'Show symbols outline' },

            -- winshift
            { 'n', '<leader>ws', ':WinShift<CR>', { noremap = true, silent = true }, 'Toggle window shifter' },

            -- Viewport manipulation
            { 'n', '<leader><C-w>', ':bd<CR>', { noremap = true }, 'Destroy buffer' },
            { 'n', '<leader><C-q>', '<cmd>%bd<cr>', { noremap = true }, 'Destroy all buffers' },
            { 'n',  '<leader>+', '<C-W>4>', { noremap = true }, 'Increase horizontal split size' },
            { 'n',  '<leader>-', '<C-W>4<', { noremap = true }, 'Decrease horizontal split size '},
            { 'n',  '<leader>?', '<C-W>4+', { noremap = true }, 'Increase vertical split size' },
            { 'n',  '<leader>_', '<C-W>4-', { noremap = true }, 'Decrease vertical split size' },

            -- Rebind arrows
            { 'n',  '<Up>', '<C-y>', { noremap = true }, 'Scroll up' },
            { 'n',  '<Down>', '<C-e>', { noremap = true }, 'Scroll down' },
            { 'n',  '<Right>', 'gt', { noremap = true }, 'Switch tab left' },
            { 'n',  '<Left>', 'gT', { noremap = true }, 'Swtich tab right' },
        }
    },

    lsp = {
        flags = {
            debounce_text_changes = 150,
        },
        options = {
            omnifunc = 'v:lua.vim.lsp.omnifunc'
        },
        signs = {
            DiagnosticSignError = { text = '', texthl = 'DiagnosticError' },
            DiagnosticSignWarn = { text = '', texthl = 'DiagnosticWarn' },
            DiagnosticSignInfo = { text = '', texthl = 'DiagnosticInfo' },
            DiagnosticSignHint = { text = '', texthl = 'DiagnosticHint' }
        },
        servers = {
            --dartls = {}, -- See flutter-tools
            ccls = {},
            jsonls = {},
            dockerls = {},
            yamlls = {},
            pylsp = {},
            cssls = {},
            vuels = {},
            html = {},
            rust_analyzer = {},
            svelte = {},
            tsserver = {},
            stylelint_lsp = {},
            arduino_language_server = {
                cmd =  {
                    'arduino-language-server',
                    '-cli-config',
                    '$HOME/.arduino15/arduino-cli.yaml',
                }
            },
            tailwindcss = {
                cmd = { '/usr/local/bin/tailwindcss-language-server', '--stdio' }
            },
            vala_ls = {},
            intelephense = {
                init_options = {
                    licenceKey = secrets.intelephense.licenceKey,
                },
            },
            sumneko_lua = {
                cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                            path = vim.split(package.path, ','),
                        },
                        diagnostics = {
                            globals = {'vim'},
                        },
                        workspace = {
                            library = {
                                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                                [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                            },
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            },
        },
        handlers = {
            ['textDocument/publishDiagnostics'] = {
                virtual_text = false
            },
            ['textDocument/hover'] = {
                border = border_style
            },
            ['textDocument/signatureHelp'] = {
                border = border_style
            }
        }
    },

    --
    -- Plugins
    --

    packer = {
        options = {},
        load = {
            -- Dependencies
            'wbthomason/packer.nvim',
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'kyazdani42/nvim-web-devicons',
            'ryanoasis/vim-devicons',
            'nvim-treesitter/nvim-treesitter',

            -- UI
            'xiyaowong/nvim-cursorword',
            'haringsrob/nvim_context_vt',
            'norcalli/nvim-colorizer.lua',
            'hoob3rt/lualine.nvim',
            'arkav/lualine-lsp-progress',
            'onsails/lspkind-nvim',
            'lewis6991/gitsigns.nvim',
            'sindrets/winshift.nvim',
            'rmagatti/goto-preview',
            'maaslalani/nordbuddy',

            -- Treesitter
            'JoosepAlviste/nvim-ts-context-commentstring',
            'nvim-treesitter/nvim-treesitter-textobjects',
            'windwp/nvim-ts-autotag',

            -- Non-treesitter
            'arrufat/vala.vim',

            -- Editing
            'tpope/vim-commentary',
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
            'akinsho/nvim-toggleterm.lua',
            'stevearc/vim-arduino',

            -- Autocomplete
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-nvim-lsp',
            'andersevenrud/compe-tmux',
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',

            -- LSP
            'jose-elias-alvarez/nvim-lsp-ts-utils',
            'neovim/nvim-lspconfig',
            'alexaandru/nvim-lspupdate',
            'akinsho/flutter-tools.nvim',
            'jose-elias-alvarez/null-ls.nvim',
        }
    },

    flutter_tools = {
        flutter_path = '/mnt/ssd-data/flutter/bin/flutter',
        lsp = {
            capabilities = function(config)
                return neovim.create_cmp_capabilities(config)
            end,
        }
    },

    npairs = {
        options = {
            disable_filetype = { 'TelescopePrompt' },
            check_ts = true,
        },
    },

    markdown_composer = {
        autostart = 0
    },

    dap_virtual_text = {
        enabled = true
    },

    dap_install = {
        setup = {},
        install = {
          -- 'php_dbg',
          -- 'jsnode_dbg',
          -- 'dart_dbg'
        }
    },

    gitsigns = {
        current_line_blame = true,
        current_line_blame_opts = {
            delay = 500,
        },
    },

    lualine = {
        options = {
            theme = 'nord',
        },
        sections = {
            lualine_a = { { 'mode', upper = true } },
            lualine_b = { { 'branch', icon = '' }, { 'diagnostics', sources = { 'nvim_lsp' } } },
            lualine_c = { { 'filename', file_status = true }, 'lsp_progress', neovim.lualine_arduino },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
        },
    },

    cmp = function(cmp)
        return {
            completion = {
                --autocomplete = false,
            },
            sources = {
                { name = 'nvim_lua' },
                { name = 'nvim_lsp' },
                { name = 'buffer' },
                { name = 'luasnip' },
                { name = 'tmux' }
            },
            snippet = {
                expand = function(args)
                    require'luasnip'.lsp_expand(args.body)
                end
            },
            formatting = {
                format = function(entry, vim_item)
                    vim_item.kind = require'lspkind'.presets.default[vim_item.kind]
                    return vim_item
                end
            },
            mapping = {
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.close(),
                ['<CR>'] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
                })
            },
        }
    end,

    treesitter = {
        ensure_installed = {
            --'jsdoc', -- Seems to slow things down at the moment (issue #1313)
            --'comment', -- todo-comments replaces this
            'typescript',
            'javascript',
            'dart',
            'c',
            'cpp',
            'c_sharp',
            'go',
            'css',
            'bash',
            'html',
            'json',
            'lua',
            'teal',
            'python',
            'c',
            'cpp',
            'regex',
            'vue',
            'php',
            'rust',
            'svelte',
            'tsx',
            'yaml',
            'toml',
            'ruby',
            'jsonc',
            'graphql',
            'dockerfile',
            'commonlisp',
        },
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
        context_commentstring = { -- Plugin
            enable = true,
        },
        autotag = { -- Plugin
            enable = true,
        },
        textobjects = { -- Plugin
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner',
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ['<leader>a'] = '@parameter.inner',
                },
                swap_previous = {
                    ['<leader>A'] = '@parameter.inner',
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    [']m'] = '@function.outer',
                    [']]'] = '@class.outer',
                },
                goto_next_end = {
                    [']M'] = '@function.outer',
                    [']['] = '@class.outer',
                },
                goto_previous_start = {
                    ['[m'] = '@function.outer',
                    ['[['] = '@class.outer',
                },
                goto_previous_end = {
                    ['[M'] = '@function.outer',
                    ['[]'] = '@class.outer',
                },
            }
        },
    },

    telescope = {
        setup = {
            builtin = {
                treesitter = true,
            },
            defaults = {
                file_ignore_patterns = neovim.wildcars_to_table(wildignore)
            }
        },
        extensions = {
            'flutter'
        }
    },

    numb = {
       show_numbers = true,
       show_cursorline = true
    },

    colorizer = {
        filetypes = {
            'html',
            'css',
            'scss',
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact',
            'vue',
            'svelte',
            'twig',
            'lua',
        },
        options = {
            css = true
        }
    },

    nvim_tree = {
        options = {
            auto_close = true,
            lsp_diagnostics = true,
        },
        global = {
            ignore = { '.git', '.cache' },
            gitignore = true,
            add_trailing = true,
            git_hl = true,
            indent_markers = true,
            quit_on_open = true
        }
    },

    nordbuddy = {
        italic_comments = true
    },

    nvim_toggleterm = {
      open_mapping = [[<leader>t]],
      shell = 'bash'
    },

    winshift = {
        highlight_moving_win = true,
        focused_hl_group = 'WinShift',
    },

    nullls = {
        bin = {
            ['package.json'] = 'node_modules/.bin/',
            ['composer.json'] = 'vendor/bin/'
        },
        formatting = {
            { 'eslint', 'package.json' },
            { 'prettier', 'package.json' },
            { 'phpcsfixer', 'composer.json' },
            { 'stylua', 'stylua.toml' },
        },
        diagnostics = {
            { 'eslint', 'package.json' },
            { 'phpcs', 'composer.json' },
            { 'luacheck' }
        }
    }
}, shims)
