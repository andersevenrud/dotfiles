--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local config = require'config'
local neovim = require'neovim'
local plugins = require'plugins'

-- Base configuration
neovim.set_options(config.vim.options)
neovim.set_highlights(config.vim.highlights)
neovim.set_aliases(config.vim.aliases)
neovim.set_rules(config.vim.rules)
neovim.set_keymaps(config.vim.keybindings)
neovim.set_lsp_signs(config.lsp.signs)

-- Highlight group for trailing whitespaces
vim.cmd [[autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/]]
vim.cmd [[autocmd InsertLeave * match ExtraWhitespace /\s\+$/]]

-- Tmux widow titles
if os.getenv('TMUX') then
  vim.cmd [[autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window %")]]
  vim.cmd [[autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))]]
  vim.cmd [[autocmd VimLeave * call system("tmux rename-window bash")]]
  vim.cmd [[autocmd BufEnter * let &titlestring = ' ' . expand("%:t")]]
end

-- Customize LSP handlers
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    config.lsp.on_publish_diagnostics
)
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    config.lsp.hover
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    config.lsp.signature_help
)

-- Plugins
plugins.load()
