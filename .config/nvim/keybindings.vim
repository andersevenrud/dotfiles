"
" NeoVim 0.5+ Configuration by
" Anders Evenrud <andersevenrud@gmail.com>
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Make C-c behave like ESC
inoremap <C-c> <ESC>

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

"nnoremap <F10> :Neogit<CR>
"nnoremap <F34> :Neogit commit<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lazygit
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <F10> :LazyGit<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <F36> :NvimTreeRefresh<CR>
nnoremap <F12> :NvimTreeFindFile<CR>
nnoremap <F11> :NvimTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Compe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' }) " ('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

imap <expr> <Tab>   v:lua.tab_complete()
smap <expr> <Tab>   v:lua.tab_complete()
imap <expr> <S-Tab> v:lua.s_tab_complete()
smap <expr> <S-Tab> v:lua.s_tab_complete()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" barbar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <A-<> :BufferMovePrevious<CR>
nnoremap <silent> <A->> :BufferMoveNext<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim snip
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

imap <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<C-j>'
imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

nmap s <Plug>(vsnip-select-text)
xmap s <Plug>(vsnip-select-text)
nmap S <Plug>(vsnip-cut-text)
xmap S <Plug>(vsnip-cut-text)

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

nnoremap <leader>xx <cmd>LspTroubleToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" symbols-outline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <F9> :SymbolsOutline<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nvim-lsp-ts-utils
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup tsbindings
  autocmd! tsbindings
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer> <silent> Lo :TSLspOrganize<CR>
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer> <silent> Lf :TSLspFixCurrent<CR>
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer> <silent> Lr :TSLspRenameFile<CR>
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer> <silent> Li :TSLspImportAll<CR>
augroup end
