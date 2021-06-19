# Neovim configuration

My **neovim 0.5+** configuration.

## Features

* Auto tags, indentation, parentheses, etc.
* Autocompletion and auto-import
* Full LSP integration w/diagnostics
* Git integration
* File browser
* Fuzzy finder
* Snippets
* Debugger

Configured language servers:

* Docker
* YAML
* JSON
* Python
* Lua
* Rust
* Dart
* PHP
* TypeScript
* JavaScript
* CSS
* HTML
* Vue
* Svelte

Configured additional diagnostics:

* eslint
* stylelint
* prettier
* phpcs

Additional language support:

* TypeScript
* Flutter
* Markdown

## Prerequisites

### Requirements

- `neovim >= 0.5` compiled with `tree-sitter`, `lua` and `python`
- [`packer.nvim`](https://github.com/wbthomason/packer.nvim) for plugin management
- `ripgrep`
- `git`

### Optional

- `nerd-fonts` for icons and symbols
- `nodejs` for language misc servers
- `rust` for certain plugins
- `rust_analyzer` for rust language server
- `lua-language-server` for lua language server
- `überzug` for image previews in telescope

### Secrets

Set up a secrets file in `~/.config/nvim/lua/secrets.lua` with this template:

```lua
return {
  intelephense = {
    licenceKey = "abc123"
  }
}
```

## Structure

* `init.vim` - Root file
* `lua/neovim.lua` - Neovim setup
* `lua/config.lua` - General Configurations
* `lua/diagnostics.lua` - Diagnostic configurations
* `lua/plugins.lua` - Plugins

## Setup

1. Use `:PackerInstall` to install plugins and everything else is set up the next time neovim is started.
2. Use `:LspUpdate` to install language servers.

## Notes

Some language servers implementations does not provide the following natively:

* progress status updates
* signature autocompletion via snippets

There are also some bugs:

* Indentation of multiline comments is [not working correctly](https://github.com/nvim-treesitter/nvim-treesitter/projects/6)

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
