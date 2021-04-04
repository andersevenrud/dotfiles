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
        require'nvim-ts-autotag'.setup{}
    end
}

-- Hide the inline diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false;
        underline = true;
        signs = true;
    }
)
vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]]
vim.cmd [[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()]]

-------------------------------------------------------------------------------
-- plugin: Misc
-------------------------------------------------------------------------------

require'lsp_signature'.on_attach()

require'lspsaga'.init_lsp_saga{}

require'lspkind'.init{}

require'neogit'.setup{}

-------------------------------------------------------------------------------
-- plugin: barbar
-------------------------------------------------------------------------------

vim.g.bufferline = {
    tabpages = false;
    auto_hide = true;
    animation = false;
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
        lualine_c = { { 'filename', file_status = true } };
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
        'rust'
    },
    context_commentstring = {
        enable = true;
    },
    highlight = {
        enable = true;
    },
    indent = {
        enable = true;
    },
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
-- plugin: lightbulb
-------------------------------------------------------------------------------

require'nvim-lightbulb'.update_lightbulb{
    virtual_text = {
        enabled = false;
    },
}

vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
