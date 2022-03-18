--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local neovim = require'andersevenrud.neovim'
local shims = require'andersevenrud.shims'

local secrets = neovim.prequire('andersevenrud.secrets', {
    intelephense = {
        licenceKey = nil
    }
})

local border_style = 'single'

local signs = {
    error = '',
    warning = '',
    info = '',
    hint = '',
}

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
    'DS_Store', 'storybook-static'
}

neovim.load({
    vim = {
        autocommands = autocommands,
        options = {
            shortmess = 'filnxtToOFc',                  -- Silence warnings and abbreviate stuff
            completeopt = { 'menuone', 'noselect' },    -- Always open popup and user selection
            pumheight = 30,                             -- Limit height of autocomplete popup
            signcolumn = 'yes',                         -- Use sign column in gutter to prevent jumping
            numberwidth = 4,                            -- Wide number gutter
            number = true,                              -- Show number gutter
            relativenumber = true,                      -- Show number gutter as relative number
            termguicolors = true,                       -- Respect terminal colors
            smartcase = true,                           -- Smart case handling in search
            ignorecase = true,                          -- Ignore casing in highlights etc
            showmode = false,                           -- No show mode
            wrap = false,                               -- No text wrapping
            showmatch = true,                           -- Show matching brackets, etc
            cursorline = true,                          -- Show cursor line hightlight
            title = true,                               -- Use window title
            expandtab = true,                           -- Spaces, not tabs
            tabstop = 2,                                -- Default spacing
            softtabstop = 2,                            -- Default spacing
            shiftwidth = 2,                             -- Default spacing
            foldlevel = 999,                            -- Expand all folds by default
            foldcolumn = 'auto',                        -- Show fold indicator in gutter
            foldmethod = 'expr',                        -- Use custom folding
            foldexpr = 'nvim_treesitter#foldexpr()',    -- Use tree-sitter for folding
            foldcolumndigits = false,                   -- Remove fold column level digits
            wildignore = wildignore,                    -- Ignore these file types
            lazyredraw = true,                          -- Reduce flicker in macros etc.
            updatetime = 1000,                          -- Lower CursorHold update times
            laststatus = 3,                             -- Global statusline
            fillchars = {
                foldopen = '',
                foldclose = '',
            },
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
            { 'i', '<Tab>', [[luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>']], { silent = true, expr = true }, 'Jump to next in snippet' },
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
                    { 'n', '<space>e', [[<cmd>lua vim.diagnostic.open_float(0, { scope = 'line', focusable = false, show_header = false })<CR>]], { noremap = true, silent = true }, 'Show lined diagnostics' },
                    { 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true }, 'Go to prev diagnostic' },
                    { 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true }, 'Go to next diagnostic' },
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
            debounce_text_changes = 250,
        },
        options = {
            omnifunc = 'v:lua.vim.lsp.omnifunc'
        },
        servers = {
            --dartls = {}, -- See flutter-tools
            bashls = {},
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
            omnisharp = {},
            sumneko_lua = neovim.create_sumneko_server_options({
                Lua = {
                    telemetry = {
                        enable = false,
                    },
                }
            }),
            arduino_language_server = {
                cmd =  {
                    'arduino-language-server',
                    '-cli-config',
                    '$HOME/.arduino15/arduino-cli.yaml',
                }
            },
            emmet_ls = {
                filetypes = {
                    'html',
                    'css',
                    'scss',
                    'vue',
                    'svelte',
                    'twig',
                }
            },
            tailwindcss = {},
            vala_ls = {},
            intelephense = {
                init_options = {
                    licenceKey = secrets.intelephense.licenceKey,
                    globalStoragePath = '~/.config/intelephense'
                },
            },
        },
        handlers = {
            ['textDocument/hover'] = {
                border = border_style
            },
            ['textDocument/signatureHelp'] = {
                border = border_style
            }
        }
    },

    diagnostics = {
        options = {
            virtual_text = false,
            float = {


            },
        },
        signs = {
            DiagnosticSignError = { text = signs.error, texthl = 'DiagnosticError' },
            DiagnosticSignWarn = { text = signs.warning, texthl = 'DiagnosticWarn' },
            DiagnosticSignInfo = { text = signs.info, texthl = 'DiagnosticInfo' },
            DiagnosticSignHint = { text = signs.hint, texthl = 'DiagnosticHint' }
        },
    },

    --
    -- Plugins
    --

    packer = {
        options = { },
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
            'onsails/lspkind-nvim',
            'lewis6991/gitsigns.nvim',
            'sindrets/winshift.nvim',
            'rmagatti/goto-preview',
            'stevearc/dressing.nvim',
            'andersevenrud/nordic.nvim',
            'anuvyklack/pretty-fold.nvim',

            -- Editing
            'numToStr/Comment.nvim',
            'matze/vim-move',
            'windwp/nvim-autopairs',

            -- Navigation
            'nvim-treesitter/nvim-treesitter-textobjects',
            --'simrat39/symbols-outline.nvim',
            'folke/todo-comments.nvim',
            'nacro90/numb.nvim',
            'nvim-telescope/telescope.nvim',
            'kyazdani42/nvim-tree.lua',
            'ggandor/lightspeed.nvim',

            -- Debugging
            'mfussenegger/nvim-dap',
            'theHamsta/nvim-dap-virtual-text',
            'Pocco81/DAPInstall.nvim',

            -- Utilities
            'wincent/terminus',
            'gpanders/editorconfig.nvim',
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
            'hrsh7th/cmp-cmdline',
            'andersevenrud/cmp-tmux',
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
            'ray-x/lsp_signature.nvim',
            'windwp/nvim-ts-autotag',
            'RRethy/nvim-treesitter-endwise',

            -- LSP
            'jose-elias-alvarez/nvim-lsp-ts-utils',
            'neovim/nvim-lspconfig',
            'williamboman/nvim-lsp-installer',
            'akinsho/flutter-tools.nvim',
            'jose-elias-alvarez/null-ls.nvim',
            'j-hui/fidget.nvim',
        }
    },

    flutter_tools = {
        --flutter_path = '/mnt/ssd-data/flutter/bin/flutter',
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
            lualine_b = { { 'branch', icon = '' }, { 'filename', file_status = true, symbols = { modified = ' ', readonly = ' ' } }, 'filetype', 'diagnostics' },
            lualine_c = { },
            lualine_x = { neovim.lualine_arduino, 'filesize' },
            lualine_y = { 'encoding', 'fileformat' },
            lualine_z = { 'progress', 'location' },
        },
    },

    cmp = function(cmp)
        local menu = {}

        local sources = {
            { name = 'nvim_lua' },
            { name = 'nvim_lsp' },
            {
                name = 'buffer',
                get_bufnrs = function()
                    local bufs = {}
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        bufs[vim.api.nvim_win_get_buf(win)] = true
                    end
                    return vim.tbl_keys(bufs)
                    --return vim.api.nvim_list_bufs()
                end
            },
            { name = 'luasnip' },
            { name = 'tmux', option = { all_panes = true } }
        }

        for _, v in pairs(sources) do
            menu[v.name] = v.name
        end

        return {
            cmp = {
                sources = sources,
                completion = {
                    --autocomplete = false,
                },
                snippet = {
                    expand = function(args)
                        require'luasnip'.lsp_expand(args.body)
                    end
                },
                formatting = {
                    format = require('lspkind').cmp_format({
                        with_text = true,
                        menu = menu,
                    }),
                },
                mapping = {
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true })
                },
            },
            cmdline = {
                ['/'] = {
                    sources = { { name = 'buffer' } }
                },
                [':'] = {
                    sources = { { name = 'cmdline' } }
                },
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
            'markdown',
            'make',
            'vala',
            'scss',
        },
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
        endwise = { -- Plugin
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
            --'flutter'
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
            ignore = { '.git', '.cache' },
            git = {
                ignore = true,
            },
            auto_close = true,
              diagnostics = {
                enable = false,
                icons = signs
            },
        },
        global = {
            add_trailing = true,
            git_hl = true,
            indent_markers = true,
        }
    },

    nordic = {
        italic_comments = true,
        alternate_backgrounds = true,
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
        options= {
            debounce = 500,
        },
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
    },

    tsutils = {
        filter_out_diagnostics_by_code = { 80001 },
    },

    lsp_signature = {
        bind = true,
        hint_enable = false,
    },

    pretty_fold = {
        fill_char = ' ',
    },
}, shims)
