--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local vim = vim
local secrets = require'secrets' -- ~/.config/nvim/lua/secrets.lua
local nvim_lsp = require'lspconfig'
local npairs = require'nvim-autopairs'

-------------------------------------------------------------------------------
-- Globals
-------------------------------------------------------------------------------

local border_style = 'single'

local telescope_extensions = {}
local telescope_options = {}

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
-- LSP
-------------------------------------------------------------------------------

local servers = {
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
    --dartls = { -- See flutter-tools
    --    cmd = {
    --        'dart',
    --        '/opt/dart-sdk/bin/snapshots/analysis_server.dart.snapshot',
    --        '--lsp'
    --    }
    --},
}

-- Initialize language server with options
for k, v in pairs(servers) do
    local options = vim.tbl_extend('keep', {
      capabilities = capabilities,
    }, v)

    nvim_lsp[k].setup(options)
end

-- Hide the inline diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false
    }
)

-- Sets up borders around certain popups
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = border_style
    }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        border = border_style
    }
)

-- Assign icons
vim.fn.sign_define('LspDiagnosticsSignError', { text = '' })
vim.fn.sign_define('LspDiagnosticsSignWarning', { text = '' })
vim.fn.sign_define('LspDiagnosticsSignInformation', { text = '' })
vim.fn.sign_define('LspDiagnosticsSignHint', { text = '' })

-------------------------------------------------------------------------------
-- plugin: flutter-tools
-------------------------------------------------------------------------------

require'flutter-tools'.setup{ -- This also intializes dartls LSP
    flutter_path = '/mnt/ssd-data/flutter/bin/flutter',
    lsp = {
        capabilities = capabilities,
    }
}

table.insert(telescope_extensions, 'flutter')

-------------------------------------------------------------------------------
-- plugin: diagnosticls-nvim
-------------------------------------------------------------------------------

local phpcs = require'diagnosticls-nvim.linters.phpcs'
local eslintDefaults = require'diagnosticls-nvim.linters.eslint'
local stylelintDefaults = require'diagnosticls-nvim.linters.stylelint'
local prettierDefaults = require 'diagnosticls-nvim.formatters.prettier'
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

local diagnostic_groups = {
    eslint = {
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte', 'vue' },
        options = { linter = eslint, formatter = prettier }
    },
    stylelint = {
        filetypes = { 'scss', 'less', 'css' },
        options = { linter = stylelint }
    },
    phpcs = {
        filetypes = { 'php' },
        options = { linter = phpcs }
    }
}

local diagnostics = {}
for _, v in pairs(diagnostic_groups) do
    for _, ft in ipairs(v.filetypes) do
        diagnostics[ft] = v.options
    end
end

require'diagnosticls-nvim'.init{}
require'diagnosticls-nvim'.setup(diagnostics) -- This also initializes diagnostcls LSP

-------------------------------------------------------------------------------
-- plugin: lspkind
-------------------------------------------------------------------------------

require'lspkind'.init{}

-------------------------------------------------------------------------------
-- plugin: autopairs
-------------------------------------------------------------------------------

npairs.setup{
    disable_filetype = { 'TelescopePrompt' },
    check_ts = true,
}

-------------------------------------------------------------------------------
-- plugin: lsp_signature
-------------------------------------------------------------------------------

require'lsp_signature'.on_attach{
    bind = false,
    floating_window = true,
    handler_opts = {
        border = border_style
    }
}

-------------------------------------------------------------------------------
-- plugin: markdown-composer
-------------------------------------------------------------------------------

vim.g.markdown_composer_autostart = 0

-------------------------------------------------------------------------------
-- plugin: nvim-dap-virtual-text
-------------------------------------------------------------------------------

vim.g.dap_virtual_text = true

-------------------------------------------------------------------------------
-- plugin: dapinstall
-------------------------------------------------------------------------------

local dap_install = require'dap-install'
local dbg_list = { 'php_dbg', 'jsnode_dbg', 'dart_dbg' }

dap_install.setup{}

for _, debugger in ipairs(dbg_list) do
    dap_install.config(debugger, {})
end

-------------------------------------------------------------------------------
-- plugin: gitsigns
-------------------------------------------------------------------------------

require'gitsigns'.setup{
    current_line_blame = true,
    current_line_blame_delay = 500
}

-------------------------------------------------------------------------------
-- plugin: lualine
-------------------------------------------------------------------------------

require'lualine'.setup{
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
}

-------------------------------------------------------------------------------
-- plugin: compe
-------------------------------------------------------------------------------

require'compe'.setup{
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
}

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

-------------------------------------------------------------------------------
-- plugin: nvim-treesitter
-------------------------------------------------------------------------------

require'nvim-treesitter.configs'.setup{
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

    -- Plugins
    context_commentstring = {
        enable = true,
    },
    autotag = {
        enable = true,
    }
}

-------------------------------------------------------------------------------
-- plugin: telescope
-------------------------------------------------------------------------------

local telescope = require'telescope'
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

telescope.setup(vim.tbl_extend('keep', {
    builtin = {
        treesitter = true,
    },
    defaults = {
        file_ignore_patterns = file_ignore_patterns
    }
}, telescope_options))

for _, v in ipairs(telescope_extensions) do
    telescope.load_extension(v)
end

-------------------------------------------------------------------------------
-- plugin: numb
-------------------------------------------------------------------------------

require'numb'.setup{
   show_numbers = true,
   show_cursorline = true,
}

-------------------------------------------------------------------------------
-- plugin: colorizer
-------------------------------------------------------------------------------

require'colorizer'.setup({
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
}, {
    css = true,
})

-------------------------------------------------------------------------------
-- plugin: trouble
-------------------------------------------------------------------------------

require'trouble'.setup{}

-------------------------------------------------------------------------------
-- plugin: nvim-tree
-------------------------------------------------------------------------------

vim.g.nvim_tree_ignore = { '.git', '.cache' }
vim.g.nvim_tree_gitignore = true
vim.g.nvim_tree_auto_close = true
vim.g.nvim_tree_add_trailing = true
vim.g.nvim_tree_lsp_diagnostics = true
vim.g.nvim_tree_git_hl = true
vim.g.nvim_tree_add_trailing = true
vim.g.nvim_tree_indent_markers = true
vim.g.nvim_tree_quit_on_open = true

-------------------------------------------------------------------------------
-- plugin: neogit
-------------------------------------------------------------------------------

require'neogit'.setup{}

-------------------------------------------------------------------------------
-- plugin: todo-comments
-------------------------------------------------------------------------------

require'todo-comments'.setup{}

-------------------------------------------------------------------------------
-- plugin: diffview
-------------------------------------------------------------------------------

require'diffview'.setup{}

-------------------------------------------------------------------------------
-- plugin: vsnip
-------------------------------------------------------------------------------

-- Run vsnip on startup and not on demand to reduce latency on initial completion
vim.api.nvim_exec('autocmd FileType * call vsnip#get_complete_items(bufnr())', false)
