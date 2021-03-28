--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local secrets = require('secrets') -- ~/.config/nvim/lua/secrets.lua
local nvim_lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.dockerls.setup{
    capabilities = capabilities
}
nvim_lsp.yamlls.setup{
    capabilities = capabilities
}
nvim_lsp.pyls.setup{
    capabilities = capabilities
}
nvim_lsp.vuels.setup{
    capabilities = capabilities
}
nvim_lsp.cssls.setup{
    capabilities = capabilities
}
nvim_lsp.vuels.setup{
    capabilities = capabilities
}
nvim_lsp.html.setup {
    capabilities = capabilities
}
nvim_lsp.intelephense.setup{
    capabilities = capabilities,
    init_options = {
        licenceKey = secrets.intelephense.licenceKey
    }
}

-- Superseded in plugins.lua
-- nvim_lsp.tsserver.setup {
--     capabilities = capabilities
-- }

-- Hide the inline diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        underline = true,
        signs = true,
    }
)
vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]]
vim.cmd [[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()]]
