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
neovim.set_lsp_options(config.lsp.options)

-- Highlight group for trailing whitespaces
neovim.autocmds{
    { { 'InsertEnter' }, '*', [[match ExtraWhitespace /\s\+\%#\@<!$/]] },
    { { 'InsertLeave' }, '*', [[match ExtraWhitespace /\s\+$/]] }
}

-- Tmux widow titles
if os.getenv('TMUX') then
    neovim.autocmds{
        { { 'BufReadPost', 'FileReadPost', 'BufNewFile' },  '*', [[call system("tmux rename-window %")]] },
        { { 'BufEnter' }, '*', [[call system("tmux rename-window " . expand("%:t"))]] },
        { { 'VimLeave' }, '*', [[call system("tmux rename-window bash")]] },
        { { 'BufEnter' }, '*', [[let &titlestring = ' ' . expand("%:t")]] }
    }
end

-- Plugins
plugins.load()
