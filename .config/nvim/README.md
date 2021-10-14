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
* Nord

## Dependencies

- `neovim >= 0.5`
- `ripgrep`
- `git`
- [`packer.nvim`](https://github.com/wbthomason/packer.nvim) for plugin management
- [`nerd-fonts`](https://www.nerdfonts.com/) for icons and symbols

### Optional

- `nodejs` for language servers/tools
- `rust` for language servers/tools
- `php` for language servers/tools
- Language servers not covered by automatic installer
  - [`arduino-language-server`](https://github.com/arduino/arduino-language-server)
  - [`stylua`](https://github.com/JohnnyMorganz/StyLua)
  - [`luacheck`](https://github.com/mpeterv/luacheck)
  - [`ccls`](https://github.com/MaskRay/ccls)

## Setup

1. Use `:PackerInstall` to install plugins and everything else is set up the next time neovim is started.
2. Use `:LspInstallAll` to install all language servers at once (instead of on-demand)

Secrets are stored in the optional file `lua/andersevenrud/secrets.lua`:

```lua
return {
  intelephense = {
    licenceKey = "abc123"
  }
}
```

## Configured Languages

| Language         | Completion | Diagnostics | Formatting | Debugging |
| ---------------- | ---------- | ----------- | ---------- | --------- |
| Docker           | Y          | Y           |            |           |
| YAML             | Y          | Y           |            |           |
| JSON             |            | Y           | Y          |           |
| C/C++            | Y          | Y           | Y          | Y         |
| Python           | Y          | Y           | Y          | Y         |
| Lua              | Y          | Y           | Y          |           |
| Rust             | Y          | Y           |            |           |
| Dart (Flutter)   | Y          | Y           | Y          | Y         |
| PHP              | Y          | Y           | Y          | Y         |
| TypeScript       | Y          | Y           | Y          | Y         |
| JavaScript       | Y          | Y           | Y          | Y         |
| CSS              | Y          | Y           | Y          |           |
| Tailwind         | Y          | Y           | Y          |           |
| HTML             | Y          |             |            |           |
| Vue              | Y          | Y           | Y          |           |
| Svelte           | Y          | Y           | Y          |           |
| Arduino          | Y          | Y           | Y          |           |
| Mardown          |            |             |            | Y         |

## Custom Keybindings

| Mode     | LSP          | Binding          | Description                            |
| -------- | ------------ | ---------------- | -------------------------------------- |
| i        |              | `<Tab>`          | Jump to next in snippet                |
| i        |              | `<S-Tab>`        | Jump to prev in snippet                |
| s        |              | `<Tab>`          | Jump to next in snippet                |
| s        |              | `<S-Tab>`        | Jump to prev in snippet                |
| i        |              | `<C-E>`          | Next snippet choice                    |
| s        |              | `<C-E>`          | Next snippet choice                    |
| n        | `*`          | `gD`             | Go to decleration                      |
| n        | `*`          | `gd`             | Go to definition                       |
| n        | `*`          | `K`              | Show documentation                     |
| n        | `*`          | `gi`             | Go to implementation                   |
| n        | `*`          | `gr`             | Go to reference(s)                     |
| n        | `*`          | `<C-k>`          | Show signature help                    |
| i        | `*`          | `<C-A-k>`        | Show signature help                    |
| n        | `*`          | `<space>wa`      | Add workspace                          |
| n        | `*`          | `<space>wr`      | Remove workspace                       |
| n        | `*`          | `<space>wl`      | List workspaces                        |
| n        | `*`          | `<space>D`       | Show type definition                   |
| n        | `*`          | `<space>rn`      | Rename current                         |
| n        | `*`          | `<space>ca`      | Show code actions                      |
| n        | `*`          | `<space>f`       | Format document                        |
| n        | `*`          | `<space>q`       | Set location list item                 |
| n        | `*`          | `<space>e`       | Show lined diagnostics                 |
| n        | `*`          | `[d`             | Go to prev diagnostic                  |
| n        | `*`          | `]d`             | Go to next diagnostic                  |
| n        | `*`          | `gpd`            | Go to definition (preview)             |
| n        | `*`          | `gpi`            | Go to implementation (preview)         |
| n        | `*`          | `gP`             | Close all previews                     |
| n        | `tsserver`   | `<space>ri`      | Organize imports                       |
| n        | `tsserver`   | `<space>cf`      | Fix current                            |
| n        | `tsserver`   | `<space>rwn`     | Rename file across workspace           |
| n        | `tsserver`   | `<space>ia`      | Import all used definitions            |
| n        |              | `<leader>ff`     | Fuzzy find files                       |
| n        |              | `<leader>fg`     | Fuzzy grep                             |
| n        |              | `<leader>fb`     | Fuzzy buffers                          |
| n        |              | `<leader>fh`     | Fuzzy help                             |
| n        |              | `<leader>fd`     | Fuzzy diagnostics                      |
| n        |              | `<leader>go`     | Open neogit                            |
| n        |              | `<leader>fr`     | Refresh file browser                   |
| n        |              | `<leader>fo`     | Open file browser                      |
| n        |              | `<leader>ft`     | Toggle file browser                    |
| n        |              | `<leader>fs`     | Show symbols outline                   |
| n        |              | `<leader>ws`     | Toggle window shifter                  |
| n        |              | `<leader><C-w>`  | Destroy buffer                         |
| n        |              | `<leader><C-q>`  | Destroy all buffers                    |
| n        |              | `<leader>+`      | Increase horizontal split size         |
| n        |              | `<leader>-`      | Decrease horizontal split size         |
| n        |              | `<leader>?`      | Increase vertical split size           |
| n        |              | `<leader>_`      | Decrease vertical split size           |
| n        |              | `<Up>`           | Scroll up                              |
| n        |              | `<Down>`         | Scroll down                            |
| n        |              | `<Right>`        | Switch tab left                        |
| n        |              | `<Left>`         | Swtich tab right                       |


## Troubleshooting

### Treesitter ABI version conflicts

* Build a fresh version of neovim nightly
* Nuke `~/.config/nvim/plugins/tree-sitter/parser/` directory
* Start up neovim again and it will install the defined parsers
  * If this is not enabled, use `:TSInstallFromGrammar` command

### Treesitter indentation issues

Indentation of multiline comments is [not working correctly](https://github.com/nvim-treesitter/nvim-treesitter/projects/6) for all grammars.
