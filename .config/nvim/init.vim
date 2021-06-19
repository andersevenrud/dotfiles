"
" NeoVim 0.5+ Configuration by
" Anders Evenrud <andersevenrud@gmail.com>
"

lua require('plugins')
lua require('neovim')

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

" Rebind horizontal arrows to tab switching
nnoremap <Right> gt
nnoremap <Left>  gT

" Close all buffers
nnoremap <leader>bd <cmd>%bd<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> gD        <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gd        <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K         <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi        <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr        <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <C-k>     <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <space>wa <cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
nnoremap <silent> <space>wr <cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
nnoremap <silent> <space>wl <cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
nnoremap <silent> <space>D  <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <space>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <space>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <space>f  <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <space>q  <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <silent> <space>e  <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> [d        <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d        <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Telescope keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>ff <cmd>lua require'telescope.builtin'.find_files()<cr>
nnoremap <leader>fg <cmd>lua require'telescope.builtin'.live_grep()<cr>
nnoremap <leader>fb <cmd>lua require'telescope.builtin'.buffers()<cr>
nnoremap <leader>fh <cmd>lua require'telescope.builtin'.help_tags()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neogit keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent><leader>go :Neogit<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Tree keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>fr :NvimTreeRefresh<CR>
nnoremap <leader>fo :NvimTreeFindFile<CR>
nnoremap <leader>ft :NvimTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Compe keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim snip keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" trouble keybindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent><leader>fd <cmd>LspTroubleToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" symbols-outline keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent><leader>fs :SymbolsOutline<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nvim-lsp-ts-utils keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup tsbindings
  autocmd! tsbindings
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer><silent><leader>lo :TSLspOrganize<CR>
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer><silent><leader>lf :TSLspFixCurrent<CR>
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer><silent><leader>lr :TSLspRenameFile<CR>
  autocmd Filetype typescript,javascript,typescriptreact,javascriptreact nmap <buffer><silent><leader>li :TSLspImportAll<CR>
augroup end
