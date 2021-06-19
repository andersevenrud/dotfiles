--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local config = require'config'
local nvim_lsp = require'lspconfig'

------------------------------------------------------------------------------
-- LSP
------------------------------------------------------------------------------

-- Initialize language server with options
for k, v in pairs(config.lsp_config) do
    local options = vim.tbl_extend('keep', {
        capabilities = config.lsp.capabilities
    }, v)

    nvim_lsp[k].setup(options)
end

-- Hide the inline diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    config.lsp.on_publish_diagnostics
)

-- Sets up borders around certain popups
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    config.lsp.hover
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    config.lsp.signature_help
)

-- Assign icons
for k, v in pairs(config.signs) do vim.fn.sign_define(k, v) end

------------------------------------------------------------------------------
-- Plugins
------------------------------------------------------------------------------

-- Globals
vim.g.dap_virtual_text = config.dap_virtual_text.enabled

for k, v in pairs(config.nordbuddy) do vim.g['nord_' .. k] = v end
for k, v in pairs(config.markdown_composer) do vim.g['markdown_composer_' .. k] = v end
for k, v in pairs(config.nvim_tree) do vim.g['nvim_tree_' .. k] = v end

-- Setups
require'colorbuddy'.colorscheme(config.colorbuddy.colorscheme)
require'flutter-tools'.setup(config.flutter_tools)
require'diagnosticls-nvim'.init{}
require'diagnosticls-nvim'.setup(config.diagnosticls)
require'nvim-autopairs'.setup(config.npairs)
require'lsp_signature'.on_attach(config.lsp_signature)
require'dap-install'.setup(config.dap_install.setup)
require'gitsigns'.setup(config.gitsigns)
require'lualine'.setup(config.lualine)
require'nvim-treesitter.configs'.setup(config.treesitter)
require'telescope'.setup(config.telescope.setup)
require'numb'.setup(config.numb)
require'colorizer'.setup(config.colorizer.filetypes, config.colorizer.options)
require'neogit'.setup(config.neogit)
require'compe'.setup(config.compe)
require'trouble'.setup{}
require'lspkind'.init{}
require'todo-comments'.setup{}
require'diffview'.setup{}

-- Late bindings
for _, v in ipairs(config.dap_install.install) do require'dap-install'.config(v, {}) end
for _, v in ipairs(config.telescope.extensions) do require'telescope'.load_extension(v) end

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

-- Run vsnip on startup and not on demand to reduce latency on initial completion
vim.api.nvim_exec('autocmd FileType * call vsnip#get_complete_items(bufnr())', false)
