--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local secrets = require'secrets' -- ~/.config/nvim/lua/secrets.lua
local phpcs = require'diagnosticls-nvim.linters.phpcs'
local eslintDefaults = require'diagnosticls-nvim.linters.eslint'
local stylelintDefaults = require'diagnosticls-nvim.linters.stylelint'
local prettierDefaults = require 'diagnosticls-nvim.formatters.prettier'

-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------
-- Telescope
-------------------------------------------------------------------------------

local file_ignore_patterns = {
    'package-lock.json',
    'yarn.lock',
    'composer.lock'
}

for _, v in pairs(vim.split(vim.o.wildignore, ',')) do
    -- A very crude way to use wildignore list
    local p = v:gsub('^*.(%a+)$', '%%.%1')
    table.insert(file_ignore_patterns, p)
end

-------------------------------------------------------------------------------
-- Diagnostics
-------------------------------------------------------------------------------

local linterDefaults = { debounce = 1000 }

local eslint = vim.tbl_extend('keep', {
    command = 'node_modules/.bin/eslint',
    rootPatterns = { 'package.json' },
    securities = {
        [1] = 'error',
        [2] = 'warning'
    },
    requiredFiles = vim.tbl_extend('keep', {
        'package.json'
    }, eslintDefaults.rootPatterns)
}, linterDefaults, eslintDefaults)

local stylelint = vim.tbl_extend('keep', {
    command = 'node_modules/.bin/stylelint',
    rootPatterns = { 'package.json' },
    requiredFiles = vim.tbl_extend('keep', {
        'package.json',
        '.stylelintrc',
        'stylelint.config.js'
    }, stylelintDefaults.rootPatterns)
}, linterDefaults, stylelintDefaults)

local prettier = vim.tbl_extend('keep', {
    command = 'node_modules/.bin/prettier',
    rootPatterns = { 'package.json' },
    requiredFiles = vim.tbl_extend('keep', {
        'package.json'
    }, prettierDefaults.rootPatterns)
}, prettierDefaults)

local diagnostics = {
    {
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte', 'vue' },
        options = { linter = eslint, formatter = prettier }
    },
    {
        filetypes = { 'scss', 'less', 'css' },
        options = { linter = stylelint }
    },
    {
        filetypes = { 'php' },
        options = { linter = phpcs }
    }
}

local diagnosticls = {}
for _, v in ipairs(diagnostics) do
    for _, ft in ipairs(v.filetypes) do
        diagnosticls[ft] = v.options
    end
end

-------------------------------------------------------------------------------
-- Export
-------------------------------------------------------------------------------

local M = {
    diagnosticls = diagnosticls,

    signs = {
        LspDiagnosticsSignError = { text = '' },
        LspDiagnosticsSignWarning = { text = '' },
        LspDiagnosticsSignInformation = { text = '' },
        LspDiagnosticsSignHint = { text = '' }
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
        }
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
        intelephense = {
            init_options = {
                licenceKey = secrets.intelephense.licenceKey,
            },
        },
        tsserver = {
            on_attach = function(client)
                local ts_utils = require'nvim-lsp-ts-utils'
                ts_utils.setup{}
                ts_utils.setup_client(client)
            end
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
                file_ignore_patterns = file_ignore_patterns
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

return M
