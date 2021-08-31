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
local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
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
            {
                lsp = '*',
                keybindings = {
                    { 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true } },
                    { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true } },
                    { 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true } },
                    { 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true } },
                    { 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true } },
                    { 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true } },
                    { 'i', '<C-A-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true } },
                    { 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { noremap = true, silent = true } },
                    { 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { noremap = true, silent = true } },
                    { 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', { noremap = true, silent = true } },
                    { 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true } },
                    { 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true } },
                    { 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true } },
                    { 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true } },
                    { 'n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', { noremap = true, silent = true } },
                    { 'n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false, show_header = false })<CR>', { noremap = true, silent = true } },
                    { 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, silent = true } },
                    { 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, silent = true } },
                }
            },

            -- Telescope
            { 'n', '<leader>ff', [[<cmd>lua require'telescope.builtin'.find_files()<cr>]], { noremap = true } },
            { 'n', '<leader>fg', [[<cmd>lua require'telescope.builtin'.live_grep()<cr>]], { noremap = true } },
            { 'n', '<leader>fb', [[<cmd>lua require'telescope.builtin'.buffers()<cr>]], { noremap = true } },
            { 'n', '<leader>fh', [[<cmd>lua require'telescope.builtin'.help_tags()<cr>]], { noremap = true } },
            { 'n', '<leader>fd', [[<cmd>lua require'telescope.builtin'.lsp_workspace_diagnostics()<cr>]], { noremap = true } },

            -- neogit
            { 'n', '<leader>go', ':Neogit<CR>', { noremap = true, silent = true } },

            -- nvim-tree
            { 'n', '<leader>fr', ':NvimTreeRefresh<CR>', { noremap = true } },
            { 'n', '<leader>fo', ':NvimTreeFindFile<CR>', { noremap = true } },
            { 'n', '<leader>ft', ':NvimTreeToggle<CR>', { noremap = true } },

            -- compe
            -- { 'i', '<C-Space>', [[<cmd>lua require'cmp'.mapping.complete()<cr>]], { noremap = true, silent = true } },
            -- { 'i', '<CR>', [[<cmd>lua require'cmp'.mapping.confirm({ behavior = 'insert', select = true })<cr>]], { noremap = true, silent = true } },
            -- { 'i', '<C-e>', [[<cmd>lua require'cmp'.mapping.close()<cr>]], { noremap = true, silent = true } },
            -- { 'i', '<C-f>', [[<cmd>lua require'cmp'.mapping.scroll_docs(4)<cr>]], { noremap = true, silent = true } },
            -- { 'i', '<C-d>', [[<cmd>lua require'cmp'.mapping.scroll_docs(-4)<cr>]], { noremap = true, silent = true } },

            -- vsnip
            { 'i', '<C-l>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']], { expr = true } },
            { 's', '<C-l>', [[vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']], { expr = true } },

            -- symbols-outline
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
        flags = {
            debounce_text_changes = 150,
        },
        signs = {
            LspDiagnosticsSignError = { text = '' },
            LspDiagnosticsSignWarning = { text = '' },
            LspDiagnosticsSignInformation = { text = '' },
            LspDiagnosticsSignHint = { text = '' }
        },
        servers = {
            --diagnosticls = {}, -- see diagnosticls-configs-nvim
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
            tailwindcss = {
                cmd = { "/usr/local/bin/tailwindcss-language-server", "--stdio" }
            },
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
        options = {
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
        options = {
            profile = {
                enable = false
            }
        },
        load = {
            -- Dependencies
            'wbthomason/packer.nvim',
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'kyazdani42/nvim-web-devicons',
            'ryanoasis/vim-devicons',
            'nvim-treesitter/nvim-treesitter',

            -- UI
            'romgrk/nvim-treesitter-context',
            'dominikduda/vim_current_word', -- vimscript
            'haringsrob/nvim_context_vt',
            'norcalli/nvim-colorizer.lua',
            'hoob3rt/lualine.nvim',
            'arkav/lualine-lsp-progress',
            'onsails/lspkind-nvim',
            'lewis6991/gitsigns.nvim',
            'maaslalani/nordbuddy',

            -- Treesitter
            'JoosepAlviste/nvim-ts-context-commentstring',
            'nvim-treesitter/nvim-treesitter-textobjects',
            'windwp/nvim-ts-autotag',

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

            -- Autocomplete
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-nvim-lsp',
            'andersevenrud/compe-tmux',
            'hrsh7th/vim-vsnip',
            'rafamadriz/friendly-snippets',

            -- LSP
            'jose-elias-alvarez/nvim-lsp-ts-utils',
            'neovim/nvim-lspconfig',
            'alexaandru/nvim-lspupdate',
            'creativenull/diagnosticls-configs-nvim',
            'akinsho/flutter-tools.nvim',
            'RishabhRD/nvim-lsputils',
        }
    },

    flutter_tools = {
        flutter_path = '/mnt/ssd-data/flutter/bin/flutter',
        lsp = {
            capabilities = capabilities,
        }
    },

    npairs = {
        options = {
            disable_filetype = { 'TelescopePrompt' },
            check_ts = true,
        },
        rules = {
            { '``', '`' }
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

    cmp = {
        completion = {
            autocomplete = false
        },
        sources = {
            { name = 'nvim_lua' },
            { name = 'nvim_lsp' },
            { name = 'buffer' },
            { name = 'tmux', opts = { all_panes = true } }
        },
    },

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
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>A"] = "@parameter.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
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

    nvim_toggleterm = {
      open_mapping = [[<leader>t]],
      shell = 'bash'
    }
}, shims)
