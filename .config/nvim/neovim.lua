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

nvim_lsp.jsonls.setup{}
nvim_lsp.dockerls.setup{
    capabilities = capabilities;
}
nvim_lsp.yamlls.setup{
    capabilities = capabilities;
}
nvim_lsp.pyls.setup{
    capabilities = capabilities;
}
nvim_lsp.cssls.setup{
    capabilities = capabilities;
}
nvim_lsp.vuels.setup{
    capabilities = capabilities;
}
nvim_lsp.html.setup{
    capabilities = capabilities;
}
nvim_lsp.rust_analyzer.setup{
    capabilities = capabilities;
}
nvim_lsp.intelephense.setup{
    capabilities = capabilities;
    init_options = {
        licenceKey = secrets.intelephense.licenceKey;
    },
}
nvim_lsp.tsserver.setup{
    capabilities = capabilities,
    on_attach = function()
        require'nvim-lsp-ts-utils'.setup{}
    end
}
nvim_lsp.svelte.setup{
    capabilities = capabilities,
}
nvim_lsp.sumneko_lua.setup{
    cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
    capabilities = capabilities,
}

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
--        cmd = {
--            'dart',
--            '/opt/dart-sdk/bin/snapshots/analysis_server.dart.snapshot',
--            '--lsp'
--        }
    }
}

-------------------------------------------------------------------------------
-- plugin: diagnosticls-nvim
-------------------------------------------------------------------------------

local phpcs = require 'diagnosticls-nvim.linters.phpcs'

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
}, require 'diagnosticls-nvim.linters.eslint')

local stylelint = vim.tbl_extend('keep', {
    command = 'node_modules/.bin/stylelint',
    rootPatterns = { 'package.json' },
    requiredFiles = {
        '.stylelintrc',
        'package.json'
    }
}, require 'diagnosticls-nvim.linters.stylelint')

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

vim.cmd [[autocmd CursorHold * lua require'lspsaga.diagnostic'.show_cursor_diagnostics()]]
vim.cmd [[autocmd CursorHoldI * silent! lua require'lspsaga.signaturehelp'.signature_help()]]

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
-- plugin: indent-blankline
-------------------------------------------------------------------------------

-- vim.g.indent_blankline_show_trailing_blankline_indent = false
-- vim.g.indent_blankline_char = '│'
-- vim.g.indent_blankline_buftype_exclude = { 'help', 'terminal' }
-- vim.g.indent_blankline_use_treesitter = true
-- vim.g.indent_blankline_show_first_indent_level = false
-- 
-- vim.cmd [[autocmd FileType markdown let g:indent_blankline_enabled=v:false]]

-------------------------------------------------------------------------------
-- plugin: markdown-composer
-------------------------------------------------------------------------------

vim.g.markdown_composer_autostart = 0

-------------------------------------------------------------------------------
-- plugin: nvcode-color-schemes
-------------------------------------------------------------------------------

vim.g.nvcode_termcolors = 256

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
        path = true;
        buffer = true;
        nvim_lsp = true;
        nvim_lua = true;
        vsnip = true;
        tmux = {
            all_panes =  true;
        },
        tabnine = {
            max_num_results = 6;
            priority = 0;
            max_line = 1000;
            show_prediction_strength = true;
            ignore_pattern = '[(]'
        },
    },
}

vim.cmd [[autocmd User CompeConfirmDone :Lspsaga signature_help]]

-- Tabbing keybindingss
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif vim.fn.call('vsnip#available', {1}) == 1 then
    return t '<Plug>(vsnip-expand-or-jump)'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  elseif vim.fn.call('vsnip#jumpable', {-1}) == 1 then
    return t '<Plug>(vsnip-jump-prev)'
  else
    return t '<S-Tab>'
  end
end

-- Enter keybidinging
vim.g.completion_confirm_key = ''

_G.completion_confirm = function()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()['selected'] ~= -1 then
      return vim.fn['compe#confirm'](npairs.esc('<cr>'))
    else
      return npairs.esc('<cr>')
    end
  else
    return npairs.autopairs_cr()
  end
end

-- Add basic snippet support when language server does not
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
        'typescript',
        'javascript',
        'jsdoc',
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
        'jsdoc',
        'tsx'
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
-- plugin: lazygit
-------------------------------------------------------------------------------

vim.g.lazygit_floating_window_use_plenary = true

-------------------------------------------------------------------------------
-- plugin: cursorline
-------------------------------------------------------------------------------

vim.g.cursorword_cursorline_timeout = 300
