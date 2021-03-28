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

Optional:

- patched (nerd) fonts
- rust

### Secrets

Secrets are stored in `~/.config/nvim/lua/secrets.lua`:

```lua
return {
  intelephense = {
    licenceKey = "abc123"
  }
}
```

### LSP

These are the dependecies to make LSP integration work for configured servers:

```bash
npm install -g typescript typescript-language-server
npm install -g vscode-css-languageserver-bin
npm install -g vls
npm install -g diagnostic-languageserver
npm install -g yaml-language-server
npm install -g intelephense
npm install -g dockerfile-language-server-nodejs
npm install -g vscode-html-languageserver-bin
pip install 'python-language-server[all]'
```

## Setup

Use `:PlugInstall` to install plugins and everything else is set up the next time
neovim is started.

## TODO

* Signature autocompletion via compe is not fully working
* LSP Server status in status line (if it's initing, indexing, etc.)

## Troubleshooting

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
