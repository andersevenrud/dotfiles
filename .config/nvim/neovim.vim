"
" NeoVim 0.5+ Configuration by
" Anders Evenrud <andersevenrud@gmail.com>
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" general settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set shortmess+=c                        " Silence warnings
set completeopt=menuone,noselect        " Always open popup and user selection
set backspace=indent,eol,start          " Backspace context
set pumheight=30                        " Limit height of autocomplete popup
set signcolumn=yes                      " Use sign column in gutter to prevent jumping
set numberwidth=4                       " Wide number gutter
set number rnu                          " Show number gutter as relative number
set termguicolors                       " Respect terminal colors
set hidden                              " Allow jumping between unsaved buffers
set smartcase                           " Smart case handling in search
set ignorecase                          " Ignore casing in highlights etc
set incsearch                           " Incremental searches
set noshowmode                          " No show mode
set noerrorbells                        " No error bells
set visualbell                          " No visual bells
set nowrap                              " No text wrapping
set hlsearch                            " Highlight searches
set showmatch                           " Show matching brackets, etc
set ruler                               " Show ruler in status
set cursorline                          " Show cursor line hightlight
set title                               " Use window title
set ai                                  " Use autoindent
set expandtab                           " Spaces, not tabs
set tabstop=2                           " Default spacing
set softtabstop=2                       " Default spacing
set shiftwidth=2                        " Default spacing
set foldlevel=999                       " Expand all folds by default
set updatetime=1000                     " Lower CursorHold update times
set foldmethod=expr                     " Use custom folding
set foldexpr=nvim_treesitter#foldexpr() " Use tree-sitter for folding

" Show symbols for certain special characters
set list listchars=nbsp:¬,tab:·\ ,trail:.,precedes:<,extends:>

" Ignore these files and directories
set wildignore+=*.o,*.a,*.class,*.mo,*.la,*.so,*.obj
set wildignore+=*.swp,.tern-port,*.tmp
set wildignore+=*.jpg,*.jpeg,*.png,*.xpm,*.gif,*.bmp,*.ico
set wildignore+=.git,.svn,CVS
set wildignore+=DS_Store

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" auto commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Custom filetypes
autocmd BufNewFile,BufRead *.heml set ft=html
autocmd BufNewFile,BufRead *.rasi set ft=css
autocmd BufNewFile,BufRead *.tl set ft=teal

" Language rules
autocmd FileType lua    setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype php    setlocal tabstop=4 softtabstop=4 shiftwidth=4

" Highlight group for trailing whitespaces
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" Tmux window titles
if exists('$TMUX')
  autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window %")
  autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))
  autocmd VimLeave * call system("tmux rename-window bash")
  autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" theme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:nord_italic_comments = v:true

colorscheme nordbuddy

highlight link LspDiagnosticsUnderlineError DiffDelete
highlight link LspDiagnosticsUnderlineWarning DiffChange
highlight link GitSignsCurrentLineBlame tscomment
highlight link ExtraWhitespace RedrawDebugRecompose
highlight LineNr ctermbg=NONE guibg=NONE
