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
for k, v in pairs(config.lsp.signs) do vim.fn.sign_define(k, v) end
