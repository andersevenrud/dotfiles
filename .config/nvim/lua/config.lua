--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local secrets = require'secrets'
local neovim = require'neovim'

local border_style = 'single'
local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

return {
    vim = {
        options = {
            shortmess = 'filnxtToOFc',                  -- Silence warnings and abbreviate stuff
            completeopt = { 'menuone', 'noselect' },    -- Always open popup and user selection
            backspace = { 'indent', 'eol', 'start' },   -- Backspace context
            pumheight = 30,                             -- Limit height of autocomplete popup
            signcolumn = 'yes',                         -- Use sign column in gutter to prevent jumping
            numberwidth = 4,                            -- Wide number gutter
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
            listchars = {                               -- Show symbols for certain special characters
                nbsp = '¬',
                tab = '·\\',
                trail = '.',
                precedes = '<',
                extends = '>'
            },

            wildignore = {                               -- Ignore these file types
                '*.o', '*.a', '*.class', '*.mo', '*.la', '*.so', '*.obj',
                '*.swp', '.tern-port', '*.tmp',
                '*.jpg', '*.jpeg', '*.png', '*.xpm', '*.gif', '*.bmp', '*.ico',
                '.git', '.svn', 'CVS',
                'DS_Store'
            }
        },
        highlights = {
            LspDiagnosticsUnderlineError = { link = 'DiffDelete' },
            LspDiagnosticsUnderlineWarning = { link = 'DiffChange' },
            GitSignsCurrentLineBlame = { link = 'tscomment' },
            ExtraWhitespace = { link = 'RedrawDebugRecompose' },
            LineNr = { ctermbg = 'NONE', guibg = 'NONE' },
            CurrentWordTwins = { gui = 'underline' },
            CurrentWord = { gui = 'underline' }
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
            -- Make C-c behave like ESC
            { 'i', '<C-c>', '<ESC>', { noremap = true } },

            -- Destroy buffer with C-w on leader
            { 'n', '<leader><C-w>', ':bd<CR>', { noremap = true } },

            -- Don't increment search on '*'
            { 'n', '*', '*``', { noremap = true } },
            { 'n', '*', ':keepjumps normal! mi*`i<CR>', { noremap = true } },

            -- Horizontal split resizing
            { 'n',  '<leader>+', '<C-W>4>', { noremap = true } },
            { 'n',  '<leader>-', '<C-W>4<', { noremap = true } },

            -- Vertical split resizing
            { 'n',  '<leader>?', '<C-W>4+', { noremap = true } },
            { 'n',  '<leader>_', '<C-W>4-', { noremap = true } },

            -- Rebind vertical arrows to scrolling
            { 'n',  '<Up>', '<C-y>', { noremap = true } },
            { 'n',  '<Down>', '<C-e>', { noremap = true } },

            -- Rebind horizontal arrows to tab switching
            { 'n',  '<Right>', 'gt', { noremap = true } },
            { 'n',  '<Left>', 'gT', { noremap = true } },

            -- Close all buffers
            { 'n', '<leader>bd', '<cmd>%bd<cr>', { noremap = true } },

            -- LSP
            { 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true } },
            { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true } },
            { 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true } },
            { 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true } },
            { 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true } },
            { 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true } },
            { 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { noremap = true, silent = true } },
            { 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { noremap = true, silent = true } },
            { 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', { noremap = true, silent = true } },
            { 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true } },
            { 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true } },
            { 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true } },
            { 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true } },
            { 'n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', { noremap = true, silent = true } },
            { 'n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', { noremap = true, silent = true } },
            { 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, silent = true } },
            { 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, silent = true } },

            -- Telescope
            { 'n', '<leader>ff', [[<cmd>lua require'telescope.builtin'.find_files()<cr>]], { noremap = true } },
            { 'n', '<leader>fg', [[<cmd>lua require'telescope.builtin'.live_grep()<cr>]], { noremap = true } },
            { 'n', '<leader>fb', [[<cmd>lua require'telescope.builtin'.buffers()<cr>]], { noremap = true } },
            { 'n', '<leader>fh', [[<cmd>lua require'telescope.builtin'.help_tags()<cr>]], { noremap = true } },

            -- neogit keybindings
            { 'n', '<leader>go', ':Neogit<CR>', { noremap = true, silent = true } },

            -- Vim Tree keybindings
            { 'n', '<leader>fr', ':NvimTreeRefresh<CR>', { noremap = true } },
            { 'n', '<leader>fo', ':NvimTreeFindFile<CR>', { noremap = true } },
            { 'n', '<leader>ft', ':NvimTreeToggle<CR>', { noremap = true } },

            -- Compe keybindings
            { 'i', '<C-Space>', [[compe#complete()]], { noremap = true, silent = true, expr = true } },
            { 'i', '<CR>', [[compe#confirm('<CR>')]], { noremap = true, silent = true, expr = true } },
            { 'i', '<C-e>', [[compe#close('<C-e>')]], { noremap = true, silent = true, expr = true } },
            { 'i', '<C-f>', [[compe#scroll({ 'delta': +4 })]], { noremap = true, silent = true, expr = true } },
            { 'i', '<C-d>', [[compe#scroll({ 'delta': -4 })]], { noremap = true, silent = true, expr = true } },

            -- vim snip keybindings
            { 'i', '<C-l>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']], { expr = true } },
            { 's', '<C-l>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']], { expr = true } },

            -- trouble keybindings
            { 'n', '<leader>fd', '<cmd>LspTroubleToggle<cr>', { noremap = true, silent = true } },

            -- symbols-outline keybindings
            { 'n', '<leader>fs', ':SymbolsOutline<CR>', { noremap = true, silent = true } },

            -- nvim-lsp-ts-utils
            {
                lsp = 'tsserver',
                keybindings = {
                    { 'n', '<leader>io', ':TSLspOrganize<CR>', { silent = true } },
                    { 'n', '<space>rf', ':TSLspFixCurrent<CR>', { silent = true } },
                    { 'n', '<space>rn', ':TSLspRenameFile<CR>', { silent = true } },
                    { 'n', '<leader>ia', ':TSLspImportAll<CR>', { silent = true } }
                }
            }

        }
    },

    lsp = {
        capabilities = capabilities,
        on_publish_diagnostics = {
            virtual_text = false
        },
        hover = {
            border = border_style
        },
        signature_help = {
            border = border_style
        },
        signs = {
            LspDiagnosticsSignError = { text = '' },
            LspDiagnosticsSignWarning = { text = '' },
            LspDiagnosticsSignInformation = { text = '' },
            LspDiagnosticsSignHint = { text = '' }
        },
    },

    lsp_config = {
        --diagnosticls = {}, -- see diagnosticls-nvim
        --dartls = {}, -- See flutter-tools
        tailwindcss = {
            -- NOTES: https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#tailwindcss
            cmd = { "/usr/local/bin/tailwindcss-language-server", "--stdio" }
        },
        jsonls = {},
        dockerls = {},
        yamlls = {},
        pyls = {},
        cssls = {},
        vuels = {},
        html = {},
        rust_analyzer = {},
        svelte = {},
        tsserver = {},
        intelephense = {
            init_options = {
                licenceKey = secrets.intelephense.licenceKey,
            },
        },
        sumneko_lua = {
            cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
            -- TODO: Find a way to customize this on a per-project level
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

    flutter_tools = {
        flutter_path = '/mnt/ssd-data/flutter/bin/flutter',
        lsp = {
            capabilities = capabilities,
        }
    },

    npairs = {
        disable_filetype = { 'TelescopePrompt' },
        check_ts = true,
    },

    lsp_signature = {
        bind = false,
        floating_window = true,
        handler_opts = {
            border = border_style
        }
    },

    markdown_composer = {
        autostart = 0
    },

    dap_virtual_text = {
        enabled = true
    },

    dap_install = {
        setup = {},
        install = { 'php_dbg', 'jsnode_dbg', 'dart_dbg' }
    },

    gitsigns = {
        current_line_blame = true,
        current_line_blame_delay = 500
    },

    lualine = {
        options = {
            theme = 'nord',
        },
        sections = {
            lualine_a = { { 'mode', upper = true } },
            lualine_b = { { 'branch', icon = '' }, { 'diagnostics', sources = { 'nvim_lsp' } } },
            lualine_c = { { 'filename', file_status = true }, 'lsp_progress' },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
        },
    },

    compe = {
        enabled = true,
        autocomplete = false,
        debug = false,
        min_length = 2,
        preselect = 'enable',
        throttle_time = 80,
        source_timeout = 200,
        incomplete_delay = 400,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = true,
        source = {
            buffer = true,
            nvim_lsp = true,
            nvim_lua = true,
            vsnip = true,
            path = {
                priority = 40,
            },
            tmux = {
                all_panes = true,
            },
            tabnine = {
                max_num_results = 6,
                priority = 0,
                max_line = 1000,
                show_prediction_strength = true,
                ignore_pattern = '[(]',
            },
        },
    },

    treesitter = {
        ensure_installed = {
            --'jsdoc', -- Seems to slow things down at the moment (issue #1313)
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
        }
    },

    telescope = {
        setup = {
            builtin = {
                treesitter = true,
            },
            defaults = {
                file_ignore_patterns = neovim.wildcars_to_table({
                    'package-lock.json',
                    'yarn.lock',
                    'composer.lock'
                })
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
        ignore = { '.git', '.cache' },
        gitignore = true,
        auto_close = true,
        add_trailing = true,
        lsp_diagnostics = true,
        git_hl = true,
        indent_markers = true,
        quit_on_open = true
    },

    nordbuddy = {
        italic_comments = true
    },

    colorbuddy = {
        colorscheme = 'nordbuddy'
    }
}
