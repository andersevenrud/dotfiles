--
-- NeoVim 0.5+ Configuration by
-- Anders Evenrud <andersevenrud@gmail.com>
--

local config = require'config'
local opt = vim.opt

------------------------------------------------------------------------------
-- Options
------------------------------------------------------------------------------

opt.shortmess = opt.shortmess + 'c'            -- Silence warnings
opt.completeopt = { 'menuone', 'noselect' }    -- Always open popup and user selection
opt.backspace = { 'indent', 'eol', 'start' }   -- Backspace context
opt.pumheight = 30                             -- Limit height of autocomplete popup
opt.signcolumn = 'yes'                         -- Use sign column in gutter to prevent jumping
opt.numberwidth = 4                            -- Wide number gutter
opt.relativenumber = true                      -- Show number gutter as relative number
opt.termguicolors = true                       -- Respect terminal colors
opt.hidden = true                              -- Allow jumping between unsaved buffers
opt.smartcase = true                           -- Smart case handling in search
opt.ignorecase = true                          -- Ignore casing in highlights etc
opt.incsearch = true                           -- Incremental searches
opt.showmode = false                           -- No show mode
opt.belloff = 'all'                            -- No error bells
opt.wrap = false                               -- No text wrapping
opt.hlsearch = true                            -- Highlight searches
opt.showmatch = true                           -- Show matching brackets, etc
opt.ruler = true                               -- Show ruler in status
opt.cursorline = true                          -- Show cursor line hightlight
opt.title = true                               -- Use window title
opt.ai = true                                  -- Use autoindent
opt.expandtab = true                           -- Spaces, not tabs
opt.tabstop = 2                                -- Default spacing
opt.softtabstop = 2                            -- Default spacing
opt.shiftwidth = 2                             -- Default spacing
opt.foldlevel = 999                            -- Expand all folds by default
opt.updatetime = 1000                          -- Lower CursorHold update times
opt.foldmethod = 'expr'                        -- Use custom folding
opt.foldexpr = 'nvim_treesitter#foldexpr()'    -- Use tree-sitter for folding

-- Show symbols for certain special characters
opt.listchars = { nbsp = '¬', tab = '·\\', trail = '.', precedes = '<', extends = '>' }

opt.wildignore = opt.wildignore + { '*.o', '*.a', '*.class', '*.mo', '*.la', '*.so', '*.obj' }
opt.wildignore = opt.wildignore + { '*.swp', '.tern-port', '*.tmp' }
opt.wildignore = opt.wildignore + { '*.jpg', '*.jpeg', '*.png', '*.xpm', '*.gif', '*.bmp', '*.ico' }
opt.wildignore = opt.wildignore + { '.git', '.svn', 'CVS' }
opt.wildignore = opt.wildignore + { 'DS_Store' }

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
