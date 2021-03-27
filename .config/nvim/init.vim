"
" NeoVim 0.5+ Configuration by
" Anders Evenrud <andersevenrud@gmail.com>
"
" Requirements:
"   - python3
"   - nodejs
"   - tree-sitter
"   - neovim
"   - vim-plug
"   - patched nerd fonts
"
" Language servers:
"   npm install -g typescript typescript-language-server
"   npm install -g vscode-css-languageserver-bin
"   npm install -g vls
"   npm install -g diagnostic-languageserver
"   npm install -g yaml-language-server
"   npm install -g intelephense
"   npm install -g dockerfile-language-server-nodejs
"   npm install -g vscode-html-languageserver-bin
"   pip install 'python-language-server[all]'
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.config/nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'hrsh7th/nvim-compe'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'lua'}
  Plug 'windwp/nvim-ts-autotag'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'ryanoasis/vim-devicons'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'Raimondi/delimitMate'
  Plug 'arcticicestudio/nord-vim'
  Plug 'tzachar/compe-tabnine', { 'do': './install.sh' }
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'onsails/lspkind-nvim'
  Plug 'glepnir/lspsaga.nvim'
  Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  Plug 'tpope/vim-commentary'
  Plug 'hoob3rt/lualine.nvim'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

colorscheme nord

set shortmess+=c                  " Silence warnings
set completeopt=menuone,noselect  " Always open popup and user selection
set numberwidth=6                 " Wide number gutter
set number                        " Show number gutter
set termguicolors                 " Respect terminal colors
set hidden                        " Allow jumping between unsaved buffers
set smartcase                     " Smart case handling in search
set ignorecase                    " Ignore casing in highlights etc
set incsearch                     " Incremental searches
set backspace=indent,eol,start    " Backspace context
set noshowmode                    " No show mode
set noerrorbells                  " No error bells
set visualbell                    " No visual bells
set nowrap                        " No text wrapping
set hlsearch                      " Highlight searches
set showmatch                     " Show matching brackets, etc
set ruler                         " Show ruler in status
set signcolumn=yes                " Use sign column in gutter to prevent jumping
set title                         " Use windot title
set ai                            " Use autoindent
set expandtab                     " Spaces, not tabs
set tabstop=2                     " Default spacing
set softtabstop=2                 " Default spacing
set shiftwidth=2                  " Default spacing

" Ignore these files and directories
set wildignore+=*.o,*.a,*.class,*.mo,*.la,*.so,*.obj
set wildignore+=*.*.swp,.tern-port,*.tmp
set wildignore+=*.jpg,*.jpeg,*.png,*.xpm,*.gif,*.bmp
set wildignore+=.git,.svn,CVS
set wildignore+=*/vendor/**
set wildignore+=*/node_modules/**,*/bower_components/**
set wildignore+=*/DS_Store/**

" Highlight trailing characters
highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
set list listchars=nbsp:¬,tab:>-,trail:.,precedes:<,extends:>

" Auto commands
augroup mygroup
  autocmd!

  " Custom filetypes
  autocmd BufNewFile,BufRead *.heml set ft=html

  " Language rules
  autocmd FileType lua setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype php setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType markdown let g:indentLine_enabled=0
  "autocmd FileType vue syntax sync fromstart

  " Tmux window titles
  autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window %")
  autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))
  autocmd VimLeave * call system("tmux rename-window bash")
  autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
augroup end

" Make C-c behave like ESC
inoremap <c-c> <ESC>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Nord
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_cursor_line_number_background = 1
let g:nord_underline = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indentLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:indentLine_color_term = 0
let g:indentLine_bgcolor_term = 'NONE'
let g:indentLine_color_gui = '#3b4252'
let g:indentLine_bgcolor_gui = 'NONE'
let g:indentLine_concealcursor = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Telescope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <F36> :NvimTreeRefresh<CR>
nnoremap <F12> :NvimTreeFindFile<CR>
nnoremap <F11> :NvimTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Compe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

" Explicitly enable sources
let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.tabnine = v:true
let g:compe.source.treesitter = v:true

" Skip these sources entirely
let g:loaded_compe_spell = v:true
let g:loaded_compe_path = v:true
let g:loaded_compe_nvim_lua = v:true
let g:loaded_compe_calc = v:true
let g:loaded_compe_tags = v:true
let g:loaded_compe_emoji = v:true

" Autocompletion popup bindings
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <CR>      compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' }) " ('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treesitter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=999

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TabNine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:compe.source.tabnine = {}
let g:compe.source.tabnine.max_num_results = 6
let g:compe.source.tabnine.priority = 0
let g:compe.source.tabnine.max_line = 1000

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Snip
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
nmap s <Plug>(vsnip-select-text)
xmap s <Plug>(vsnip-select-text)
nmap S <Plug>(vsnip-cut-text)
xmap S <Plug>(vsnip-cut-text)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP (Saga) keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> gh         <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
nnoremap <silent><leader>ca  <cmd>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent><leader>ca :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>
nnoremap <silent> K          <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
nnoremap <silent> <C-f>      <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
nnoremap <silent> <C-b>      <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
nnoremap <silent> gs         <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
nnoremap <silent> gr         <cmd>lua require('lspsaga.rename').rename()<CR>
nnoremap <silent> gd         <cmd>lua require'lspsaga.provider'.preview_definition()<CR>
nnoremap <silent><leader>cd  <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>
nnoremap <silent><leader>cc  <cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>
nnoremap <silent> [e         <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
nnoremap <silent> ]e         <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>
nnoremap <silent> <A-d>      <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>
tnoremap <silent> <A-d>      <C-\><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>

nnoremap <silent> gD          <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gi          <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <space>gd   <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <space>wa   <cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
nnoremap <silent> <space>wr   <cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
nnoremap <silent> <space>wl   <cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
nnoremap <silent> <space>D    <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <space>r    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <space>q    <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configurations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

lua <<EOF
local secrets = require("secrets")
local nvim_lsp = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'gitsigns'.setup()
require'nvim-ts-autotag'.setup()

require'lualine'.setup{
  options = {
    theme = 'nord'
  },
  sections = {
    lualine_a = { { 'mode', upper = true } },
    lualine_b = { { 'branch', icon = '' }, { 'diagnostics', sources = { 'nvim_lsp' } } },
    lualine_c = { { 'filename', file_status = true } },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  }
}

-- Treesitter
require'nvim-treesitter.configs'.setup{
  ensure_installed = {
    'typescript',
    'javascript',
    'css',
    'bash',
    'html',
    'json',
    'lua',
    'python',
    'c',
    'cpp',
    'regex',
    'vue'
  },
  context_commentstring = {
    enable = true
  },
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  }
}

-- Telescope
require'telescope'.setup{
  builtin = {
    treesitter = true
  }
}

-- LSP Additions
require'lsp_signature'.on_attach()
require'lspsaga'.init_lsp_saga{}

-- LSP Servers
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
nvim_lsp.tsserver.setup {
  capabilities = capabilities,
    on_attach = function(client, bufnr)
        require("nvim-lsp-ts-utils").setup {}

        -- no default maps, so you may want to define some here
        vim.api.nvim_buf_set_keymap(bufnr, "n", "Go", ":LspOrganize<CR>", {silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "Gf", ":LspFixCurrent<CR>", {silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "Gr", ":LspRenameFile<CR>", {silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "Gi", ":LspImportAll<CR>", {silent = true})
    end
}
nvim_lsp.intelephense.setup{
  capabilities = capabilities,
  init_options = {
    licenceKey = secrets.intelephense.licenceKey
  }
}

-- Hide the inline diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    underline = true,
    signs = true,
  }
)
vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]]
vim.cmd [[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()]]
EOF
