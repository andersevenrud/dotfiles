# Neovim configuration

My **neovim 0.5+** configuration.

This setup is built on custom abstractions that provides a single point of
configuration and shims in an attempt to make customization less spaghetti.

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

Hardware development:

* Arduino

## Structure

* `init.lua` - Bootstrap and configuration
* `lua/andersevenrud/neovim.lua` - Abstractions
* `lua/andersevenrud/shims.lua` - Plugin shims
* `lua/andersevenrud/secrets.lua` - Secrets (optional)

## Prerequisites

### Requirements

- `neovim >= 0.5` compiled with `tree-sitter`, `lua` and `python`
- [`packer.nvim`](https://github.com/wbthomason/packer.nvim) for plugin management
- `ripgrep`
- `git`

### Optional

- `nodejs` for language misc servers
- `cargo` for certain plugins depending on rust
- [`nerd-fonts`](https://www.nerdfonts.com/) for icons and symbols
- [`lua-language-server`](https://github.com/sumneko/lua-language-server)
- [`arduino-language-server`](https://github.com/arduino/arduino-language-server)

## Setup

1. Use `:PackerInstall` to install plugins and everything else is set up the next time neovim is started.
2. Use `:LspUpdate` to install language servers.

### Secrets

Example:

```lua
return {
  intelephense = {
    licenceKey = "abc123"
  }
}
```

## Notes

Some language servers implementations does not provide the following natively:

* progress status updates
* signature autocompletion via snippets

There are also some bugs:

* Indentation of multiline comments is [not working correctly](https://github.com/nvim-treesitter/nvim-treesitter/projects/6) for all grammars

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
