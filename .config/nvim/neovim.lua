--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local vim = vim
local secrets = require('secrets') -- ~/.config/nvim/lua/secrets.lua
local nvim_lsp = require('lspconfig')
local npairs = require('nvim-autopairs')

-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------

local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation';
        'detail';
        'additionalTextEdits';
    }
}

local servers = {
    jsonls = {};
    dockerls = {};
    yamlls = {};
    pyls = {};
    cssls = {};
    vuels = {};
    html = {};
    rust_analyzer = {};
    svelte = {};
    intelephense = {
        init_options = {
            licenceKey = secrets.intelephense.licenceKey;
        },
    };
    tsserver = {
        on_attach = function(client, bufnr)
            local ts_utils = require'nvim-lsp-ts-utils'
            ts_utils.setup{}
            ts_utils.setup_client(client)
        end
    };
    sumneko_lua = {
        cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
    };
    --dartls = { -- See flutter-tools
    --    cmd = {
    --        'dart',
    --        '/opt/dart-sdk/bin/snapshots/analysis_server.dart.snapshot',
    --        '--lsp'
    --    }
    --};
}

-- Initialize language server with options
for k, v in pairs(servers) do
    local options = vim.tbl_extend('keep', {
      capabilities = capabilities;
    }, v)

    nvim_lsp[k].setup(options)
end

-- Hide the inline diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false;
        underline = true;
        signs = true;
    }
)

-------------------------------------------------------------------------------
-- plugin: flutter-tools Flutter
-------------------------------------------------------------------------------

require'flutter-tools'.setup{ -- This also intializes dartls LSP
    flutter_path = '/mnt/ssd-data/flutter/bin/flutter',
    lsp = {
        capabilities = capabilities,
    }
}

-------------------------------------------------------------------------------
-- plugin: diagnosticls-nvim
-------------------------------------------------------------------------------

local phpcs = require 'diagnosticls-nvim.linters.phpcs'

local linterDefaults = { debounce = 1000 }

local eslint = vim.tbl_extend('keep', {
    command = 'node_modules/.bin/eslint',
    rootPatterns = { 'package.json' },
    securities = {
        [1] = 'error',
        [2] = 'warning'
    },
    requiredFiles = {
        '.eslintrc',
        'package.json'
    }
}, linterDefaults, require 'diagnosticls-nvim.linters.eslint')

local stylelint = vim.tbl_extend('keep', {
    command = 'node_modules/.bin/stylelint',
    rootPatterns = { 'package.json' },
    requiredFiles = {
        '.stylelintrc',
        'package.json'
    }
}, linterDefaults, require 'diagnosticls-nvim.linters.stylelint')

local diagnostic_groups = {
    eslint = {
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte', 'vue' };
        options = { linter = eslint }
    },
    stylelint = {
        filetypes = { 'scss', 'less', 'css' };
        options = { linter = stylelint }
    },
    phpcs = {
        filetypes = { 'php' };
        options = { linter = phpcs }
    }
}

local diagnostics = {}
for k, v in pairs(diagnostic_groups) do
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
-- plugin: saga
-------------------------------------------------------------------------------

require'lspsaga'.init_lsp_saga{
    error_sign = '';
    warn_sign = '';
    hint_sign = '';
    infor_sign = '';
    dianostic_header_icon = '   ';
    code_action_icon = ' ';
    code_action_prompt = {
        virtual_text = false
    }
}

-------------------------------------------------------------------------------
-- plugin: lsp_signature
-------------------------------------------------------------------------------

require'lsp_signature'.on_attach{
    bind = false;
    use_lspsaga = true;
}

-------------------------------------------------------------------------------
-- plugin: nvim-bufferline
-------------------------------------------------------------------------------

require'bufferline'.setup{
    options = {
        diagnostics = 'nvim_lsp';
        show_close_icon = false;
        show_buffer_close_icons = false;
        show_tab_indicators = false;
        always_show_bufferline = false;
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
-- plugin: gitsigns
-------------------------------------------------------------------------------

require'gitsigns'.setup{
    current_line_blame = true;
}

-------------------------------------------------------------------------------
-- plugin: lualine
-------------------------------------------------------------------------------

require'lualine'.setup{
    options = {
        theme = 'nord';
    },
    sections = {
        lualine_a = { { 'mode', upper = true } };
        lualine_b = { { 'branch', icon = '' }, { 'diagnostics', sources = { 'nvim_lsp' } } };
        lualine_c = { { 'filename', file_status = true }, 'lsp_progress' };
        lualine_x = { 'encoding', 'fileformat', 'filetype' };
        lualine_y = { 'progress' };
        lualine_z = { 'location' };
    },
}

-------------------------------------------------------------------------------
-- plugin: compe
-------------------------------------------------------------------------------

require'compe'.setup{
    enabled = true;
    autocomplete = false;
    debug = false;
    min_length = 2;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;
    source = {
        calc = false;
        treesitter = false;
        buffer = true;
        nvim_lsp = true;
        nvim_lua = true;
        vsnip = true;
        path = {
            priority = 40;
        },
        tmux = {
            all_panes = false;
        },
        tabnine = {
            max_num_results = 6;
            priority = 0;
            max_line = 1000;
            show_prediction_strength = true;
            ignore_pattern = '[(]';
        },
    },
}

-- Use Saga to show signature help
vim.cmd [[autocmd User CompeConfirmDone :Lspsaga signature_help]]

-- Add basic snippet support when language server does not
-- Replaces: https://github.com/windwp/nvim-autopairs#using-nvim-compe
-- Ref: https://github.com/hrsh7th/nvim-compe/issues/302
local Helper = require "compe.helper"
Helper.convert_lsp_orig = Helper.convert_lsp
Helper.convert_lsp = function(args)
    local response = args.response or {}
    local items = response.items or response
    for _, item in ipairs(items) do
        -- 2: method
        -- 3: function
        -- 4: constructor
        if item.insertText == nil and (item.kind == 2 or item.kind == 3 or item.kind == 4) then
            item.insertText = item.label .. "(${1})"
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
        enable = true;
    },
    indent = {
        enable = true;
    },

    -- Plugins

    context_commentstring = {
        enable = true;
    },
    autotag = {
        enable = true;
    }
}

-------------------------------------------------------------------------------
-- plugin: telescope
-------------------------------------------------------------------------------

local telescope = require'telescope'

telescope.setup{
    builtin = {
        treesitter = true;
    },
    media_files = {
        filetypes = { 'png', 'webp', 'jpeg', 'jpg' };
        find_cmd = 'rg';
    }
}

telescope.load_extension('flutter')
telescope.load_extension('media_files')

-------------------------------------------------------------------------------
-- plugin: numb
-------------------------------------------------------------------------------

require'numb'.setup{
   show_numbers = true;
   show_cursorline = true;
}

-------------------------------------------------------------------------------
-- plugin: colorizer
-------------------------------------------------------------------------------

require'colorizer'.setup({
    'html';
    'css';
    'scss';
    'javascript';
    'typescript';
    'javascriptreact';
    'typescriptreact';
    'vue';
    'svelte';
    'twig';
    'lua';
}, {
    css = true;
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

-------------------------------------------------------------------------------
-- plugin: neogit
-------------------------------------------------------------------------------

require'neogit'.setup{}

-------------------------------------------------------------------------------
-- plugin: cursorline
-------------------------------------------------------------------------------

vim.g.cursorword_cursorline_timeout = 300

-------------------------------------------------------------------------------
-- plugin: todo-comments
-------------------------------------------------------------------------------

require'todo-comments'.setup{}
