--
-- NeoVim 0.11+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local jsonpath = require('andersevenrud.jsonpath')
local neovim = require('andersevenrud.neovim')
local shims = require('andersevenrud.shims')
local tmux = require('andersevenrud.tmux')

local secrets = neovim.prequire('andersevenrud.secrets', {
    intelephense = {
        licenceKey = nil,
    },
})

local autocommands = {
    ['ExtraWhitespaceCommands'] = {
        { { 'InsertEnter' }, '*', [[match ExtraWhitespace /\s\+\%#\@<!$/]] },
        { { 'InsertLeave' }, '*', [[match ExtraWhitespace /\s\+$/]] },
    },
    ['YankHighlighting'] = {
        {
            { 'TextYankPost' },
            '*',
            function()
                vim.hl.on_yank({ higroup = 'IncSearch', timeout = 500, on_visual = true })
            end,
        },
    },
    ['ReloadChangedFiles'] = {
        {
            { 'FocusGained' },
            '*',
            function()
                pcall(vim.cmd, 'checktime')
            end,
        },
    },
}

local wildignore = {
    '*.o',
    '*.a',
    '*.class',
    '*.la',
    '*.so',
    '*.obj', --, '*.mo'
    '*.swp',
    '.tern-port',
    '*.tmp',
    '*.jpg',
    '*.jpeg',
    '*.png',
    '*.xpm',
    '*.gif',
    '*.bmp',
    '*.ico',
    '.git',
    '.svn',
    'CVS',
    '*.snap',
    'package-lock.json',
    'yarn.lock',
    'composer.lock',
    'DS_Store',
    'storybook-static',
}

local js_debug_configurations = {
    {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        cwd = '${workspaceFolder}',
    },
    {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach to process',
        processId = function()
            return require('dap.utils').pick_process()
        end,
        cwd = '${workspaceFolder}',
    },
}

local lldb_debug_configurations = {
    {
        type = 'codelldb',
        request = 'launch',
        name = 'Launch executable',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}

jsonpath.setup()

tmux.setup()

neovim.setup({
    vim = {
        autocommands = autocommands,

        globals = {
            mapleader = vim.fn.has('mac') == 1 and '´' or '\\', -- Key left of backspace
            copilot_no_tab_map = true, -- <Tab> is handled manually to avoid recursion
        },

        options = {
            shortmess = 'filnxtToOFcs', -- Silence warnings and abbreviate stuff
            completeopt = { 'menuone', 'noselect' }, -- Always open popup and user selection
            pumheight = 30, -- Limit height of autocomplete popup
            signcolumn = 'yes', -- Use sign column in gutter to prevent jumping
            winborder = 'single', -- Default border for floating windows (hover, signature, etc.)
            numberwidth = 4, -- Wide number gutter
            number = true, -- Show number gutter
            relativenumber = true, -- Show number gutter as relative number
            termguicolors = true, -- Respect terminal colors
            smartcase = true, -- Smart case handling in search
            ignorecase = true, -- Ignore casing in highlights etc
            showmode = false, -- No show mode
            wrap = false, -- No text wrapping
            showmatch = true, -- Show matching brackets, etc
            cursorline = true, -- Show cursor line hightlight
            title = true, -- Use window title
            expandtab = true, -- Spaces, not tabs
            tabstop = 2, -- Default spacing
            softtabstop = 2, -- Default spacing
            shiftwidth = 2, -- Default spacing
            foldlevel = 999, -- Expand all folds by default
            --foldcolumn = 'auto', -- Show fold indicator in gutter
            foldmethod = 'expr', -- Use custom folding
            foldexpr = 'v:lua.vim.treesitter.foldexpr()', -- Use tree-sitter for folding
            foldtext = '', -- Show folded line with syntax highlighting
            --foldcolumndigits = false, -- Remove fold column level digits
            wildignore = wildignore, -- Ignore these file types
            --lazyredraw = true, -- Reduce flicker in macros etc.
            updatetime = 1000, -- Lower CursorHold update times
            ttimeoutlen = 10, -- Speed up escape sequences in the terminal
            laststatus = 3, -- Global statusline
            --cmdheight = 0, -- No command line height unless entering one
            winbar = "%{expand('%:~:.')}", -- Show relative file path in winbar
            fillchars = {
                foldopen = '',
                foldclose = '',
                fold = ' ',
            },
            listchars = { -- Show symbols for certain special characters
                nbsp = '¬',
                tab = '·\\',
                trail = '.',
                precedes = '<',
                extends = '>',
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
            ['*.tl'] = 'teal',
            ['*.bicep'] = 'bicep',
            ['.*%.blade%.php'] = 'blade',
        },

        rules = {
            lua = { tabstop = 4, softtabstop = 4, shiftwidth = 4 },
            python = { tabstop = 4, softtabstop = 4, shiftwidth = 4 },
            php = { tabstop = 4, softtabstop = 4, shiftwidth = 4 },
        },

        keybindings = {
            -- luasnip
            {
                'i',
                '<Tab>',
                function()
                    local ls = require('luasnip')
                    if ls.expand_or_jumpable() then
                        ls.expand_or_jump()
                    elseif vim.fn.exists('*copilot#GetDisplayedSuggestion') == 1 and vim.fn['copilot#GetDisplayedSuggestion']().text ~= '' then
                        vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](''), 'n', false)
                    else
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', false)
                    end
                end,
                { silent = true },
                'Expand snippet, accept copilot, or tab',
            },
            { 'i', '<S-Tab>', [[<cmd>lua require'luasnip'.jump(-1)<Cr>]], { noremap = true, silent = true }, 'Jump to prev in snippet' },
            { 's', '<Tab>', [[<cmd>lua require('luasnip').jump(1)<Cr>]], { noremap = true, silent = true }, 'Jump to next in snippet' },
            { 's', '<S-Tab>', [[<cmd>lua require('luasnip').jump(-1)<Cr>]], { noremap = true, silent = true }, 'Jump to prev in snippet' },
            {
                'i',
                '<C-E>',
                function()
                    local ls = require('luasnip')
                    if ls.choice_active() then
                        ls.change_choice(1)
                    else
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-E>', true, true, true), 'n', false)
                    end
                end,
                { silent = true },
                'Next snippet choice',
            },
            {
                's',
                '<C-E>',
                function()
                    local ls = require('luasnip')
                    if ls.choice_active() then
                        ls.change_choice(1)
                    end
                end,
                { silent = true },
                'Next snippet choice',
            },

            -- LSP
            {
                lsp = '*',
                keybindings = {
                    { 'n', 'gD', '<cmd>Lspsaga peek_definition<CR>', { silent = true }, 'Peek definition' },
                    { 'n', 'gd', '<cmd>Lspsaga goto_definition<CR>', { noremap = true, silent = true }, 'Go to definition' },
                    { 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true }, 'Show documentation' },
                    { 'n', 'gi', '<cmd>Lspsaga finder<CR>', { noremap = true, silent = true }, 'Go to implementation' },
                    { 'n', 'gr', '<cmd>Lspsaga finder<CR>', { noremap = true, silent = true }, 'Go to reference(s)' },
                    { 'n', '<C-k>', '<cmd>Lspsaga signature_help<CR>', { noremap = true, silent = true }, 'Show signature help' },
                    { 'i', '<C-A-k>', '<cmd>Lspsaga signature_help<CR>', { noremap = true, silent = true }, 'Show signature help' },
                    { 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { noremap = true, silent = true }, 'Add workspace' },
                    { 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { noremap = true, silent = true }, 'Remove workspace' },
                    { 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', { noremap = true, silent = true }, 'List workspaces' },
                    { 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true }, 'Show type definition' },
                    { 'n', '<space>rn', '<cmd>Lspsaga rename<CR>', { noremap = true, silent = true }, 'Rename current' },
                    { 'n', '<space>ca', '<cmd>Lspsaga code_action<CR>', { noremap = true, silent = true }, 'Show code actions' },
                    { 'n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true }, 'Format document' },
                    { 'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true }, 'Set location list item' },
                    { 'n', '<space>e', '<cmd>Lspsaga show_line_diagnostics<CR>', { noremap = true, silent = true }, 'Show lined diagnostics' },
                    { 'n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { noremap = true, silent = true }, 'Go to prev diagnostic' },
                    { 'n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', { noremap = true, silent = true }, 'Go to next diagnostic' },
                    { 'n', '<leader>so', '<cmd>Lspsaga outline<CR>', { noremap = true, silent = true }, 'Show symbols outline' },
                },
            },

            -- Telescope
            { 'n', '<leader>ff', [[<cmd>lua require'telescope.builtin'.find_files()<cr>]], { noremap = true }, 'Fuzzy find files' },
            { 'n', '<leader>fg', [[<cmd>lua require'telescope.builtin'.live_grep()<cr>]], { noremap = true }, 'Fuzzy grep' },
            { 'n', '<leader>fb', [[<cmd>lua require'telescope.builtin'.buffers()<cr>]], { noremap = true }, 'Fuzzy buffers' },
            { 'n', '<leader>fh', [[<cmd>lua require'telescope.builtin'.help_tags()<cr>]], { noremap = true }, 'Fuzzy help' },
            { 'n', '<leader>fd', [[<cmd>lua require'telescope.builtin'.diagnostics()<cr>]], { noremap = true }, 'Fuzzy diagnostics' },
            { 'n', '<leader>fa', [[<cmd>lua require'telescope.builtin'.git_files()<cr>]], { noremap = true }, 'Fuzzy find git repo' },

            -- dap
            { 'n', '<F5>', [[<cmd>lua require'dap'.continue()<CR>]], { noremap = true, silent = true }, 'Start/continue debugging' },
            { 'n', '<F10>', [[<cmd>lua require'dap'.step_over()<CR>]], { noremap = true, silent = true }, 'Step over' },
            { 'n', '<F11>', [[<cmd>lua require'dap'.step_into()<CR>]], { noremap = true, silent = true }, 'Step into' },
            { 'n', '<F12>', [[<cmd>lua require'dap'.step_out()<CR>]], { noremap = true, silent = true }, 'Step out' },
            { 'n', '<leader>b', [[<cmd>lua require'dap'.toggle_breakpoint()<CR>]], { noremap = true, silent = true }, 'Toggle breakpoint' },
            { 'n', '<leader>B', [[<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]], { noremap = true, silent = true }, 'Set conditional breakpoint' },
            { 'n', '<leader>du', [[<cmd>lua require'dapui'.toggle()<CR>]], { noremap = true, silent = true }, 'Toggle debugger UI' },
            { { 'n', 'v' }, '<leader>de', [[<cmd>lua require'dapui'.eval()<CR>]], { noremap = true, silent = true }, 'Evaluate expression' },

            -- leap
            { { 'n', 'x', 'o' }, 's', '<Plug>(leap)', { silent = true }, 'Leap' },
            { 'n', 'S', '<Plug>(leap-from-window)', { silent = true }, 'Leap from window' },

            -- neogit
            { 'n', '<leader>go', ':Neogit<CR>', { noremap = true, silent = true }, 'Open neogit' },

            -- neo-tree
            { 'n', '<leader>fo', ':Neotree float filesystem reveal<CR>', { noremap = true }, 'Open file browser' },

            -- winshift
            { 'n', '<leader>ws', ':WinShift<CR>', { noremap = true, silent = true }, 'Toggle window shifter' },

            -- Viewport manipulation
            { 'n', '<leader><C-w>', ':bd<CR>', { noremap = true }, 'Destroy buffer' },
            { 'n', '<leader><C-q>', '<cmd>%bd<cr>', { noremap = true }, 'Destroy all buffers' },
            { 'n', '<leader>+', '<C-W>4>', { noremap = true }, 'Increase horizontal split size' },
            { 'n', '<leader>-', '<C-W>4<', { noremap = true }, 'Decrease horizontal split size ' },
            { 'n', '<leader>?', '<C-W>4+', { noremap = true }, 'Increase vertical split size' },
            { 'n', '<leader>_', '<C-W>4-', { noremap = true }, 'Decrease vertical split size' },

            -- Rebind arrows
            { 'n', '<Up>', '<C-y>', { noremap = true }, 'Scroll up' },
            { 'n', '<Down>', '<C-e>', { noremap = true }, 'Scroll down' },
            { 'n', '<Right>', 'gt', { noremap = true }, 'Switch tab right' },
            { 'n', '<Left>', 'gT', { noremap = true }, 'Switch tab left' },
        },
    },

    mason = {
        packages = {
            'stylelint-language-server',
            'js-debug-adapter',
            'debugpy',
            'php-debug-adapter',
            'codelldb',
        },
    },

    lsp = {
        --flags = {},
        servers = {
            bicep = {
                cmd = { 'bicep-lsp' },
                cmd_env = { DOTNET_ROLL_FORWARD = 'Major' },
            },
            --dartls = {}, -- See flutter-tools
            eslint = {},
            bashls = {},
            jsonls = {},
            dockerls = {},
            yamlls = {
                settings = {
                    yaml = {
                        format = {
                            enable = true,
                        },
                        schemaStore = {
                            enable = true,
                        },
                    },
                },
            },
            pylsp = {},
            cssls = {},
            html = {},
            rust_analyzer = {},
            svelte = {},
            stylelint_lsp = {},
            omnisharp = {},
            arduino_language_server = {
                cmd = neovim.create_arduino_command({
                    '~/.arduinoIDE/arduino-cli.yaml',
                    '~/.arduino15/arduino-cli.yaml',
                }),
            },
            emmet_ls = {
                filetypes = {
                    'html',
                    'css',
                    'scss',
                    'vue',
                    'svelte',
                    'twig',
                },
            },
            tailwindcss = {},
            intelephense = {
                init_options = {
                    licenceKey = secrets.intelephense.licenceKey,
                    globalStoragePath = '~/.config/intelephense',
                },
            },
            biome = {},
        },
    },

    diagnostics = {
        options = {
            virtual_text = false,
            severity_sort = true,
        },
        signs = {
            ERROR = '',
            WARN = '',
            INFO = '',
            HINT = '',
        },
    },

    lazy = {
        options = {
            install = { colorscheme = { 'nordic' } },
            change_detection = { notify = false },
            rocks = { enabled = false },
        },
        load = {
            -- Dependencies
            'nvim-treesitter/nvim-treesitter',

            -- UI
            'haringsrob/nvim_context_vt',
            'catgoose/nvim-colorizer.lua',
            'nvim-lualine/lualine.nvim',
            'lewis6991/gitsigns.nvim',
            'sindrets/winshift.nvim',
            'andersevenrud/nordic.nvim',
            'folke/snacks.nvim',
            'folke/noice.nvim',

            -- Editing
            'numToStr/Comment.nvim',
            'matze/vim-move',
            'windwp/nvim-autopairs',
            'nat-418/boole.nvim',

            -- Navigation
            'nvim-treesitter/nvim-treesitter-textobjects',
            'folke/todo-comments.nvim',
            'nacro90/numb.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-neo-tree/neo-tree.nvim',
            'https://codeberg.org/andyg/leap.nvim',

            -- Debugging
            'mfussenegger/nvim-dap',
            'rcarriga/nvim-dap-ui',
            'theHamsta/nvim-dap-virtual-text',

            -- Utilities
            'sindrets/diffview.nvim',
            'NeogitOrg/neogit',
            'euclio/vim-markdown-composer',
            'akinsho/toggleterm.nvim',
            'stevearc/vim-arduino',
            'wilriker/gcode.vim',

            -- Autocomplete
            'saghen/blink.cmp',
            'L3MON4D3/LuaSnip',
            'windwp/nvim-ts-autotag',
            'RRethy/nvim-treesitter-endwise',

            -- LSP
            'neovim/nvim-lspconfig',
            'akinsho/flutter-tools.nvim',
            'nvimdev/lspsaga.nvim',
            'pmizio/typescript-tools.nvim',

            -- AI
            'github/copilot.vim',
            'olimorris/codecompanion.nvim',
        },
    },

    flutter_tools = {
        --flutter_path = '/mnt/ssd-data/flutter/bin/flutter',
        debugger = {
            enabled = true,
        },
        lsp = {
            capabilities = function(config)
                return neovim.create_autocomplete_capabilities(config)
            end,
        },
    },

    npairs = {
        options = {
            disable_filetype = { 'TelescopePrompt' },
            check_ts = true,
        },
    },

    markdown_composer = {
        autostart = 0,
    },

    dap_virtual_text = {
        enabled = true,
    },

    dap_ui = {},

    dap = {
        adapters = {
            ['pwa-node'] = {
                type = 'server',
                host = 'localhost',
                port = '${port}',
                executable = {
                    command = 'js-debug-adapter',
                    args = { '${port}' },
                },
            },
            python = {
                type = 'executable',
                command = 'debugpy-adapter',
            },
            php = {
                type = 'executable',
                command = 'php-debug-adapter',
            },
            codelldb = {
                type = 'server',
                port = '${port}',
                executable = {
                    command = 'codelldb',
                    args = { '--port', '${port}' },
                },
            },
        },
        configurations = {
            javascript = js_debug_configurations,
            typescript = js_debug_configurations,
            javascriptreact = js_debug_configurations,
            typescriptreact = js_debug_configurations,
            python = {
                {
                    type = 'python',
                    request = 'launch',
                    name = 'Launch file',
                    program = '${file}',
                },
            },
            php = {
                {
                    type = 'php',
                    request = 'launch',
                    name = 'Listen for Xdebug',
                    port = 9003,
                },
            },
            c = lldb_debug_configurations,
            cpp = lldb_debug_configurations,
            rust = lldb_debug_configurations,
        },
    },

    gitsigns = {
        update_debounce = 200,
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
            lualine_c = {},
            lualine_x = { neovim.lualine_arduino, 'filesize' },
            lualine_y = { 'encoding', 'fileformat' },
            lualine_z = { 'progress', 'location' },
        },
    },

    treesitter = {
        options = {
            -- Parsers and queries are installed here, prepended to runtimepath
            install_dir = vim.fn.stdpath('data') .. '/site',
        },
        indent = true, -- Use tree-sitter indentation (experimental)
        languages = {
            -- Filetypes without a parser of their own, mapped onto a compatible one
            jsonc = 'json',
        },
        install = {
            --'jsdoc', -- Seems to slow things down at the moment (issue #1313)
            --'comment', -- todo-comments replaces this
            'bicep',
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
            'regex',
            'vue',
            'php',
            'perl',
            'rust',
            'svelte',
            'tsx',
            'yaml',
            'toml',
            'ruby',
            'graphql',
            'dockerfile',
            'commonlisp',
            'markdown',
            'make',
            'vala',
            'scss',
            'blade',
        },
    },

    treesitter_textobjects = {
        options = {
            select = {
                lookahead = true,
            },
            move = {
                set_jumps = true,
            },
        },
        select = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
        },
        swap = {
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
        move = {
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
        },
    },

    telescope = {
        setup = {
            builtin = {
                treesitter = true,
            },
            defaults = {
                file_ignore_patterns = neovim.wildcards_to_table(wildignore),
            },
        },
    },

    numb = {
        show_numbers = true,
        show_cursorline = true,
    },

    context_vt = {
        disable_virtual_lines = true,
    },

    colorizer = {
        -- NOTE: the built-in `vim.lsp.document_color` supports some of this already
        filetypes = {
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
            css = true,
        },
    },

    neo_tree = {
        close_if_last_window = true,
        enable_modified_markers = false,
        enable_git_status = false, -- `git status --ignored` dominates open time in large repos

        filesystem = {
            never_show = { '.git', '.cache' },
        },
        window = {
            mappings = {
                ['o'] = 'open',
            },
        },
    },

    nordic = {
        italic_comments = true,
        alternate_backgrounds = true,
    },

    nvim_toggleterm = {
        open_mapping = [[<leader>t]],
        shell = 'bash',
    },

    winshift = {
        highlight_moving_win = true,
        focused_hl_group = 'WinShift',
    },

    boole = {
        mappings = {
            increment = '<C-a>',
            decrement = '<C-x>',
        },
    },

    noice = {
        lsp = {
            hover = {
                silent = true,
            },
            override = {
                ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                ['vim.lsp.util.stylize_markdown'] = true,
                ['cmp.entry.get_documentation'] = true,
            },
        },
        notify = {
            enabled = false,
        },
        messages = {
            enabled = false,
        },
        views = {
            cmdline_popup = {
                position = {
                    row = 4,
                    col = '50%',
                },
            },
            notify = {
                top_down = false,
            },
        },
        routes = {
            -- Show @recording
            {
                view = 'notify',
                filter = { event = 'msg_showmode' },
            },
            -- Hide virtual text
            {
                filter = {
                    event = 'msg_show',
                    kind = 'search_count',
                },
                opts = { skip = true },
            },
        },
    },

    snacks = {
        input = { enabled = true },
        notifier = { enabled = true },
        picker = { enabled = true, ui_select = true },
    },

    lspsaga = {
        lightbulb = {
            virtual_text = false,
        },
    },

    blink = {
        keymap = { preset = 'enter' },
        snippets = { preset = 'luasnip' },
        fuzzy = { implementation = 'prefer_rust_with_warning' },
        completion = {
            documentation = { auto_show = true },
            accept = {
                auto_brackets = { enabled = true },
            },
        },
        cmdline = {
            completion = {
                menu = { auto_show = true },
                list = {
                    selection = {
                        preselect = false,
                    },
                },
            },
        },
        sources = {
            default = { 'lsp', 'buffer', 'snippets', 'path', 'tmux' },
            providers = {
                tmux = {
                    module = 'blink-cmp-tmux',
                    name = 'tmux',
                },
            },
        },
    },
}, shims)
