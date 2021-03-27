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

source ~/.config/nvim/plugins.vim
source ~/.config/nvim/neovim.vim
luafile ~/.config/nvim/neovim.lua
luafile ~/.config/nvim/plugins.lua
