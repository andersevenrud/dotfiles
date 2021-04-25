--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local secrets = require('secrets') -- ~/.config/nvim/lua/secrets.lua
local nvim_lsp = require('lspconfig')

-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation';
        'detail';
        'additionalTextEdits';
    }
}

nvim_lsp.dockerls.setup{
    capabilities = capabilities;
}
nvim_lsp.yamlls.setup{
    capabilities = capabilities;
}
nvim_lsp.pyls.setup{
    capabilities = capabilities;
}
nvim_lsp.vuels.setup{
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

    -- TS server plugins
    on_attach = function(client, bufnr)
        require'nvim-lsp-ts-utils'.setup{}
    end
}
nvim_lsp.svelte.setup{
    capabilities = capabilities,
}
nvim_lsp.diagnosticls.setup{
    root_dir = nvim_lsp.util.root_pattern('package.json'),
    filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'scss',
        'less',
        'css',
        'svelte',
        'vue'
    },
    init_options = {
        linters = {
            eslint = {
                command = 'node_modules/.bin/eslint',
                rootPatterns = { 'package.json' },
                debounce = 100,
                args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
                sourceName = 'eslint',
                parseJson = {
                    errorsRoot = '[0].messages',
                    line = 'line',
                    column = 'column',
                    endLine = 'endLine',
                    endColumn = 'endColumn',
                    message = '[eslint] ${message} [${ruleId}]',
                    security = 'severity'
                },
                securities = {
                    [2] = 'error',
                    [1] = 'warning'
                }
            },
            stylelint = {
                command = 'node_modules/.bin/stylelint',
                rootPatterns = { 'package.json' },
                debounce = 100,
                args = { '--formatter', 'unix', '--stdin-filename', '%filename' },
                sourceName = 'stylelint',
                isStdout = true,
                isStderr = false,
                offsetLine = 0,
                offsetColumn = 0,
                formatLines = 1,
                formatPattern = {
                    '^[^:]+:(\\d+):(\\d+):\\s(.+)\\s\\[(\\w+)\\]$',
                    {
                        line = 1,
                        column = 2,
                        message = 3,
                        security = 4
                    }
                },
                securities = {
                    [2] = 'error',
                    [1] = 'warning'
                }
            }
        },
        filetypes = {
            javascript = 'eslint',
            javascriptreact = 'eslint',
            typescript = 'eslint',
            typescriptreact = 'eslint',
            css = 'stylelint',
            scss = 'stylelint',
            less = 'stylelint'
        }
    }
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
-- plugin: Misc
-------------------------------------------------------------------------------

require'lsp_signature'.on_attach()

require'lspkind'.init{}

--require'neogit'.setup{}

require'symbols-outline'.setup{}

-------------------------------------------------------------------------------
-- plugin: saga
-------------------------------------------------------------------------------

require'lspsaga'.init_lsp_saga{}

vim.cmd [[autocmd CursorHold * lua require'lspsaga.diagnostic'.show_cursor_diagnostics()]]
vim.cmd [[autocmd CursorHoldI * silent! lua require'lspsaga.signaturehelp'.signature_help()]]

-------------------------------------------------------------------------------
-- plugin: nvim-bufferline
-------------------------------------------------------------------------------

require'bufferline'.setup{
    options = {
        diagnostics = 'nvim_lsp';
        show_buffer_close_icons = false;
        show_close_icon = false;
        show_buffer_close_icons = false;
        show_tab_indicators = false;
        always_show_bufferline = false;
    }
}

-------------------------------------------------------------------------------
-- plugin: indent-blankline
-------------------------------------------------------------------------------

vim.g.indent_blankline_show_trailing_blankline_indent = false
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_buftype_exclude = { 'help', 'terminal' }
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_show_first_indent_level = false

vim.cmd [[autocmd FileType markdown let g:indent_blankline_enabled=v:false]]

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
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;
    source = {
        path = true;
        buffer = true;
        calc = true;
        nvim_lsp = true;
        nvim_lua = true;
        vsnip = true;
        treesitter = true;
        tmux = true;
        tabnine = {
            max_num_results = 6;
            priority = 0;
            max_line = 1000;
            show_prediction_strength = true;
            ignore_pattern = '[(]'
        },
    },
}

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

require'telescope'.setup{
    builtin = {
        treesitter = true;
    },
}

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

-------------------------------------------------------------------------------
-- plugin: lazygit
-------------------------------------------------------------------------------

vim.g.lazygit_floating_window_use_plenary = true
