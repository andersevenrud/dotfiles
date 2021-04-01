# Neovim configuration

My **neovim 0.5+** configuration.

Configured to give an editor experience that is comparable with VSCode or any
other heavy lifter out there.

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

The following dependencies are required:

- python3
- nodejs
- tree-sitter
- vim-plug
- neovim 0.5 nightly compiled w/tree-sitter

Optional:

- patched (nerd) fonts
- rust_analyzer
- rust
- ripgrep

### Secrets

Secrets are stored in `~/.config/nvim/lua/secrets.lua`:

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

### Lua crashes in Neovim

Build neovim from the official github repositories, not AUR etc.

Neovim official ships with it's own third party dependencies and expects
these versions, not from the system package manager.

### Treesitter ABI version conflicts

* Make sure tree-sitter is up-to-date first
* Build a fresh version of neovim nightly
* Nuke `~/.config/nvim/plugins/tree-sitter/parser/` directory
* Start up neovim again and it will install the defined parsers
  * If this is not enabled, use `:TSInstallFromGrammar` command

### Slow compe or telescope

Disable tree-sitter integration.

### Syntax does not seem to match colorscheme

This setup relies on tree-sitter. So syntax is either not installed,
is not an option at this moment.
