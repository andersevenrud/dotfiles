# Neovim configuration

My **neovim 0.5+** configuration.

## Features

* Auto tags, indentation, parentheses, etc.
* Autocompletion and auto-import
* Full LSP integration
* Git integration
* File browser
* Fuzzy finder
* Snippets
* Debugger

## Prerequisites

### Requirements

- `neovim >= 0.5` compiled with `tree-sitter`, `lua` and `python`
- [`vim-plug`](https://github.com/junegunn/vim-plug#neovim) for plugin management

### Optional

- `nerd-fonts` for icons and symbols
- `nodejs` for language misc servers
- `rust` for certain plugins
- `rust_analyzer` for rust language server
- `ripgrep` for faster fuzzy searches

### Secrets

Set up a secrets file in `~/.config/nvim/lua/secrets.lua` with this template:

```lua
return {
  intelephense = {
    licenceKey = "abc123"
  }
}
```

## Setup

1. Use `:PlugInstall` to install plugins and everything else is set up the next time neovim is started.
2. Use `:LspUpdate` to install language servers.

## TODO

* Typing multiline comments will misalign (motions work)
* Signature autocompletion is not available in some language servers at this moment
* LSP Server status in status line (if it's initing, indexing, etc.)

## Troubleshooting

Build neovim from the official github repositories, not AUR etc.

Neovim official ships with it's own third party dependencies and expects
these versions, not from the system package manager.

### Incorrect release version or dependencies

Don't use CMake to bootstrap the source. Instead do the following:

```bash
make CMAKE_BUILD_TYPE=Release
sudo make install CMAKE_INSTALL_CONFIG_NAME=Release
```

### Treesitter ABI version conflicts

* Build a fresh version of neovim nightly
* Nuke `~/.config/nvim/plugins/tree-sitter/parser/` directory
* Start up neovim again and it will install the defined parsers
  * If this is not enabled, use `:TSInstallFromGrammar` command

### Slow compe or telescope

Disable tree-sitter integration.

### Syntax does not seem to match colorscheme

This setup relies on tree-sitter. So syntax is either not installed,
is not an option at this moment.
