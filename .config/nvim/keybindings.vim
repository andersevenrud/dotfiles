"
" NeoVim 0.5+ Configuration by
" Anders Evenrud <andersevenrud@gmail.com>
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Make C-c behave like ESC
inoremap <C-c> <ESC>

" Destroy buffer with C-w on leader
nnoremap <leader><C-w> :bd<CR>

" Don't increment search on '*'
nnoremap * *``
nnoremap * :keepjumps normal! mi*`i<CR>

" Horizontal split resizing
nnoremap <leader>+ <C-W>4>
nnoremap <leader>- <C-W>4<

" Vertical split resizing
nnoremap <leader>? <C-W>4+
nnoremap <leader>_ <C-W>4-

" Rebind vertical arrows to scrolling
nnoremap <Up> <C-y>
nnoremap <Down> <C-e>

" Rebind vertical arrows to tab switching
nnoremap <Right> gt
nnoremap <Left>  gT

" Close all buffers
nnoremap <leader>bd <cmd>%bd<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> gD        <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gi        <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <space>gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <space>wa <cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
nnoremap <silent> <space>wr <cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
nnoremap <silent> <space>wl <cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
nnoremap <silent> <space>D  <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <space>q  <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Telescope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>ff <cmd>lua require'telescope.builtin'.find_files()<cr>
nnoremap <leader>fg <cmd>lua require'telescope.builtin'.live_grep()<cr>
nnoremap <leader>fb <cmd>lua require'telescope.builtin'.buffers()<cr>
nnoremap <leader>fh <cmd>lua require'telescope.builtin'.help_tags()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neogit
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent><leader>go :Neogit<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>fr :NvimTreeRefresh<CR>
nnoremap <leader>fo :NvimTreeFindFile<CR>
nnoremap <leader>ft :NvimTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Compe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim snip
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Saga
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent><leader>gd  <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
nnoremap <silent><leader>ca  <cmd>lua require'lspsaga.codeaction'.code_action()<CR>
vnoremap <silent><leader>ca :<C-U>lua require'lspsaga.codeaction'.range_code_action()<CR>
nnoremap <silent> K          <cmd>lua require'lspsaga.hover'.render_hover_doc()<CR>
nnoremap <silent> <C-f>      <cmd>lua require'lspsaga.action'.smart_scroll_with_saga(1)<CR>
nnoremap <silent> <C-b>      <cmd>lua require'lspsaga.action'.smart_scroll_with_saga(-1)<CR>
nnoremap <silent> gs         <cmd>lua require'lspsaga.signaturehelp'.signature_help()<CR>
inoremap <silent> <C-k>      <cmd>lua require'lspsaga.signaturehelp'.signature_help()<CR>
nnoremap <silent> gr         <cmd>lua require'lspsaga.rename'.rename()<CR>
nnoremap <silent> gd         <cmd>lua require'lspsaga.provider'.preview_definition()<CR>
nnoremap <silent><leader>cd  <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>
nnoremap <silent><leader>cc  <cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>
nnoremap <silent> [e         <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
nnoremap <silent> ]e         <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>
nnoremap <silent> <A-d>      <cmd>lua require'lspsaga.floaterm'.open_float_terminal()<CR>
tnoremap <silent> <A-d>      <C-\><C-n>:lua require'lspsaga.floaterm'.close_float_terminal()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" trouble
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent><leader>fd <cmd>LspTroubleToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" symbols-outline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent><leader>fs :SymbolsOutline<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nvim-lsp-ts-utils
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup tsbindings
  autocmd! tsbindings
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer><silent><leader>lo :TSLspOrganize<CR>
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer><silent><leader>lf :TSLspFixCurrent<CR>
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer><silent><leader>lr :TSLspRenameFile<CR>
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer><silent><leader>li :TSLspImportAll<CR>
augroup end
