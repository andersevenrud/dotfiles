# Neovim configuration

My **neovim 0.5+** configuration.

This setup is built on custom abstractions that provides a single point of
configuration and shims in an attempt to make customization less spaghetti.

## Features

* Treesitter and auto pairs
* Autocompletion and snippets
* LSP and diagnostics integrations
* File browser and fuzzy finder
* Git integrations

Configured for:

| Language         | Completion | Diagnostics | Formatting | Debugging |
| ---------------- | ---------- | ----------- | ---------- | --------- |
| Docker           | Y          | Y           |            |           |
| YAML             | Y          | Y           |            |           |
| JSON             |            | Y           | Y          |           |
| Python           | Y          | Y           | Y          | Y         |
| Lua              | Y          | Y           | Y          |           |
| Rust             | Y          | Y           |            |           |
| Dart (Flutter)   | Y          | Y           | Y          | Y         |
| PHP              | Y          | Y           | Y          | Y         |
| TypeScript       | Y          | Y           | Y          | Y         |
| JavaScript       | Y          | Y           | Y          | Y         |
| CSS              | Y          | Y           | Y          |           |
| HTML             | Y          |             |            |           |
| Vue              | Y          | Y           | Y          |           |
| Svelte           | Y          | Y           | Y          |           |
| Arduino          | Y          | Y           | Y          |           |
| Mardown          |            |             |            | Y         |

## Dependencies

- `neovim >= 0.5`
- `ripgrep`
- `git`
- [`packer.nvim`](https://github.com/wbthomason/packer.nvim) for plugin management
- [`nerd-fonts`](https://www.nerdfonts.com/) for icons and symbols

### Optional

- `nodejs` for language servers
- `rust` for language servers
- [`lua-language-server`](https://github.com/sumneko/lua-language-server)
- [`arduino-language-server`](https://github.com/arduino/arduino-language-server)
- [`stylua`](https://github.com/JohnnyMorganz/StyLua)
- [`luacheck`](https://github.com/mpeterv/luacheck)
- [`ccls`](https://github.com/MaskRay/ccls)

## Setup

1. Use `:PackerInstall` to install plugins and everything else is set up the next time neovim is started.
2. Use `:LspUpdate` to install language servers (with exception of the optional dependencies above).

Secrets are stored in the optional file `lua/andersevenrud/secrets.lua`:

```lua
return {
  intelephense = {
    licenceKey = "abc123"
  }
}
```

## Keybindings

TODO -- dump this from config table(s) and create markdown table

## Troubleshooting

### Treesitter ABI version conflicts

* Build a fresh version of neovim nightly
* Nuke `~/.config/nvim/plugins/tree-sitter/parser/` directory
* Start up neovim again and it will install the defined parsers
  * If this is not enabled, use `:TSInstallFromGrammar` command

### Treesitter indentation issues

Indentation of multiline comments is [not working correctly](https://github.com/nvim-treesitter/nvim-treesitter/projects/6) for all grammars.
