"
" NeoVim 0.5+ Configuration by
" Anders Evenrud <andersevenrud@gmail.com>
"

" Theme
colorscheme nord

hi BufferCurrentMod guifg=#eceff4 ctermfg=255 guibg=#2e3440 ctermbg=237 gui=bold cterm=bold

" General options
set shortmess+=c                  " Silence warnings
set completeopt=menuone,noselect  " Always open popup and user selection
set backspace=indent,eol,start    " Backspace context
set signcolumn=yes                " Use sign column in gutter to prevent jumping
set numberwidth=4                 " Wide number gutter
set number                        " Show number gutter
set termguicolors                 " Respect terminal colors
set hidden                        " Allow jumping between unsaved buffers
set smartcase                     " Smart case handling in search
set ignorecase                    " Ignore casing in highlights etc
set incsearch                     " Incremental searches
set noshowmode                    " No show mode
set noerrorbells                  " No error bells
set visualbell                    " No visual bells
set nowrap                        " No text wrapping
set hlsearch                      " Highlight searches
set showmatch                     " Show matching brackets, etc
set ruler                         " Show ruler in status
set title                         " Use windot title
set ai                            " Use autoindent
set expandtab                     " Spaces, not tabs
set tabstop=2                     " Default spacing
set softtabstop=2                 " Default spacing
set shiftwidth=2                  " Default spacing
set foldlevel=999                 " Expand all folds by default
set updatetime=300                " Lower CursorHold update times

" Ignore these files and directories
set wildignore+=*.o,*.a,*.class,*.mo,*.la,*.so,*.obj
set wildignore+=*.*.swp,.tern-port,*.tmp
set wildignore+=*.jpg,*.jpeg,*.png,*.xpm,*.gif,*.bmp
set wildignore+=.git,.svn,CVS
set wildignore+=*/DS_Store/**

" Highlight trailing characters
highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
set list listchars=nbsp:¬,tab:>-,trail:.,precedes:<,extends:>

" Custom filetypes
autocmd BufNewFile,BufRead *.heml set ft=html

" Language rules
autocmd FileType lua    setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype php    setlocal tabstop=4 softtabstop=4 shiftwidth=4

" Tmux window titles
if exists('$TMUX')
  autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window %")
  autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))
  autocmd VimLeave * call system("tmux rename-window bash")
  autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
endif
