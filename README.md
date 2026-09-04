# scvim

A minimal Neovim configuration built with native `vim.pack` and `mini.nvim`.

## Overview

`scvim` provides a fast, self-contained development environment. It replaces complex plugin frameworks with native Neovim features and the `mini.nvim` library.

You can run `scvim` side by side with your existing Neovim configuration using `NVIM_APPNAME`.

## File Structure

- [`./init.lua`](./init.lua): Main entry point. Loads core modules and color scheme.
- [`./lua/options.lua`](./lua/options.lua): Editor options and buffer settings.
- [`./lua/keymaps.lua`](./lua/keymaps.lua): Key mappings and leader bindings.
- [`./lua/commands.lua`](./lua/commands.lua): Custom user commands for package management.
- [`./lua/autocmds.lua`](./lua/autocmds.lua): Event handlers and filetype rules.
- [`./lua/pack.lua`](./lua/pack.lua): Plugin declarations and module configurations.
- [`./lua/lsp.lua`](./lua/lsp.lua): LSP server setups and diagnostics.
- [`./lua/treesitter.lua`](./lua/treesitter.lua): Syntax parser definitions and highlight rules.
- [`./CHEATSHEET.md`](./CHEATSHEET.md): Complete keymap reference.
- [`./LANGUAGES.md`](./LANGUAGES.md): Language server and parser setup guide.
- [`./CHANGELOG.md`](./CHANGELOG.md): Record of configuration changes.

## Prerequisites

Install these tools before you start:

1. **Neovim** (version 0.12 or newer).
2. **Git** (for package downloads).
3. **C Compiler** (`gcc`, `clang`, or `zig`) and **tree-sitter-cli** (for syntax parsers).
4. **Nerd Font** (optional, for icons in statusline, pickers, and Markdown).

---

## Installation Options

### Option A: Side-by-Side Installation (Recommended)

This option keeps your current `~/.config/nvim` untouched. Neovim isolates all configuration, data, cache, and state files under `scvim`.

1. Symlink this repository to `~/.config/scvim`:

```sh
ln -s /path/to/scvim ~/.config/scvim
```

2. Add this alias to your shell configuration (`~/.zshrc` or `~/.bashrc`):

```sh
alias scvim='NVIM_APPNAME=scvim nvim'
```

3. Reload your shell configuration:

```sh
source ~/.zshrc  # or source ~/.bashrc
```

4. Launch `scvim`:

```sh
scvim
```

---

### Option B: Primary Installation (`~/.config/nvim`)

This option sets `scvim` as your default Neovim setup.

1. Move your existing configuration to a backup directory:

```sh
mv ~/.config/nvim ~/.config/nvim.backup
```

2. Symlink this repository to `~/.config/nvim`:

```sh
ln -s /path/to/scvim ~/.config/nvim
```

3. Launch Neovim:

```sh
nvim
```

---

## Language Server Setup

Install language servers with Mason after initial launch:

```vim
:MasonInstall ansible-language-server bash-language-server basedpyright css-lsp dockerfile-language-server gopls html-lsp json-lsp marksman ruff rust-analyzer taplo terraform-ls typescript-language-server yaml-language-server
```

Tree-sitter parsers install automatically on first launch via [`lua/treesitter.lua`](./lua/treesitter.lua).

---

## Package Management Commands

Use these custom commands in Neovim:

| Command              | Description                                   |
| :------------------- | :-------------------------------------------- |
| `:PackAdd <url>`     | Add a plugin to the active session.           |
| `:PackUpdate`        | Update all installed plugins.                 |
| `:PackUpdate <name>` | Update a specific plugin.                     |
| `:PackClean`         | Remove unused and inactive plugins from disk. |
| `:PackDel <name>`    | Delete a specific plugin from disk.           |

---

## Documentation

Access documentation directly in Neovim using `<leader>h`:

| Keymap       | File                             | Description                                  |
| :----------- | :------------------------------- | :------------------------------------------- |
| `<leader>hc` | [CHEATSHEET.md](./CHEATSHEET.md) | Complete keymap and shortcut reference.      |
| `<leader>hr` | [README.md](./README.md)         | Project guide and installation instructions. |
| `<leader>hl` | [CHANGELOG.md](./CHANGELOG.md)   | Complete version release history.            |
| `<leader>hk` | [LANGUAGES.md](./LANGUAGES.md)   | 15-language LSP and parser matrix.           |

---

## Acknowledgements & Inspirations

`scvim` builds upon patterns, workflows, and ideas from the Neovim community:

- **[Sin-cy/nvim-scratch](https://github.com/Sin-cy/nvim-scratch)**: Initial architectural layout and native `vim.pack` + `mini.nvim` foundation.
- **[Sin-cy/dotfiles](https://github.com/Sin-cy/dotfiles)**: Keymap ergonomics, editor behaviors, and dynamic language workflows.
- **[SylvanFranklin/.config](https://github.com/SylvanFranklin/.config)**: Package management concepts (`:PackClean`) and CSV table integration ideas.
- **[radleylewis/nvim](https://github.com/radleylewis/nvim)** (and [nvim-lite](https://github.com/radleylewis/nvim-lite)): Split navigation and resizing ergonomics, patience diffing, diagnostic sign styling, import organization workflow, cursor position restoration, clean terminal management, and runtime workspace indexing.
- **[echasnovski/mini.nvim](https://github.com/nvim-mini/mini.nvim)**: Comprehensive modular library powering core editing, diffing, and navigation.

---

## License

This project is licensed under the [MIT License](./LICENSE).
