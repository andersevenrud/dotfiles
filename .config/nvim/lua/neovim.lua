--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local config = require'config'

------------------------------------------------------------------------------
-- Options
------------------------------------------------------------------------------

-- Options
for k, v in pairs(config.vim.options) do
    vim.opt[k] = v
end

-- Highlights
for k, v in pairs(config.vim.highlights) do
    if v.link then
        vim.highlight.link(k, v.link)
    else
        vim.highlight.create(k, v)
    end
end

-- Highlight group for trailing whitespaces
vim.cmd [[autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/]]
vim.cmd [[autocmd InsertLeave * match ExtraWhitespace /\s\+$/]]

-- Custom filetypes
for k, v in pairs(config.vim.aliases) do
    vim.cmd('autocmd BufNewFile,BufRead ' .. k .. ' set ft=' .. v)
end


-- Custom rules per filetype
for k, v in pairs(config.vim.rules) do
    local locals = {}
    for a, b in pairs(v) do
        table.insert(locals, string.format('%s=%s', a, b))
    end
    vim.cmd('autocmd FileType ' .. k .. ' setlocal ' .. table.concat(locals, ' '))
end

-- Tmux widow titles
if os.getenv('TMUX') then
  vim.cmd [[autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window %")]]
  vim.cmd [[autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))]]
  vim.cmd [[autocmd VimLeave * call system("tmux rename-window bash")]]
  vim.cmd [[autocmd BufEnter * let &titlestring = ' ' . expand("%:t")]]
end

------------------------------------------------------------------------------
-- LSP
------------------------------------------------------------------------------

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
