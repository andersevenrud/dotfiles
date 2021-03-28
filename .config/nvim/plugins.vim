"
" NeoVim 0.5+ Configuration by
" Anders Evenrud <andersevenrud@gmail.com>
"

call plug#begin('~/.config/nvim/plugins')
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
  Plug 'tzachar/compe-tabnine', { 'do': './install.sh' }
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'onsails/lspkind-nvim'
  Plug 'glepnir/lspsaga.nvim'
  Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  Plug 'tpope/vim-commentary'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'kosayoda/nvim-lightbulb'
  Plug 'christianchiarulli/nvcode-color-schemes.vim'
  Plug 'f-person/git-blame.nvim'
  Plug 'mfussenegger/nvim-dap'
  Plug 'euclio/vim-markdown-composer', {'do': 'cargo build --release'}
  Plug 'TimUntersberger/neogit'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Nord
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:nvcode_termcolors=256
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_cursor_line_number_background = 1
let g:nord_underline = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indentLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:indentLine_char = '┊'
let g:indentLine_color_term = 0
let g:indentLine_bgcolor_term = 'NONE'
let g:indentLine_color_gui = '#3b4252'
let g:indentLine_bgcolor_gui = 'NONE'
let g:indentLine_concealcursor = 0

augroup mygroup
  autocmd!
  autocmd FileType markdown let g:indentLine_enabled=0
augroup end

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lightbulb
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Git Blame
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:gitblame_date_format = '%Y.%m%.%d %H:%M'
let g:gitblame_message_template = '<author> <date>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Markdown composer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:markdown_composer_autostart = 0

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
" Saga
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
