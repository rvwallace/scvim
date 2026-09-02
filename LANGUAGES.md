# Language and LSP Setup

This document lists supported languages, Tree-sitter parsers, and LSP servers.

## Supported Languages

| Language | Tree-sitter Parser | LSP Server (`lspconfig`) | Mason Package Name |
| :--- | :--- | :--- | :--- |
| **Ansible** | `yaml` | `ansiblels` | `ansible-language-server` |
| **Bash** | `bash` | `bashls` | `bash-language-server` |
| **CSS** | `css` | `cssls` | `css-lsp` |
| **Docker** | `dockerfile` | `dockerls` | `dockerfile-language-server` |
| **Go** | `go`, `gomod`, `gosum`, `gowork` | `gopls` | `gopls` |
| **HTML** | `html` | `html` | `html-lsp` |
| **JSON** | `json`, `json5` | `jsonls` | `json-lsp` |
| **Lua** | `lua`, `vim`, `vimdoc`, `query` | `lua_ls` | System or Mason `lua-language-server` |
| **Markdown** | `markdown`, `markdown_inline` | `marksman` | `marksman` |
| **Python** | `python` | `basedpyright`, `ruff` | `basedpyright`, `ruff` |
| **Rust** | `rust` | `rust_analyzer` | `rust-analyzer` |
| **Swift** | `swift` | `sourcekit` | System (`sourcekit-lsp` via Xcode / CLI Tools) |
| **Terraform / HCL** | `terraform` | `terraformls` | `terraform-ls` |
| **TOML** | `toml` | `taplo` | `taplo` |
| **TypeScript / JS** | `typescript`, `javascript`, `tsx` | `ts_ls` | `typescript-language-server` |
| **YAML** | `yaml` | `yamlls` | `yaml-language-server` |

---

## Setup Procedure on a New Machine

### Step 1: Install External Dependencies

Install runtime tools using your system package manager:

#### macOS (Homebrew)
```sh
brew install neovim tree-sitter-cli ripgrep fd
```

#### Linux (Debian / Ubuntu / Fedora / Arch)
```sh
# Ensure tree-sitter-cli, ripgrep, and build tools are available
# Fedora:
sudo dnf install neovim tree-sitter-cli ripgrep fd-find gcc
# Arch:
sudo pacman -S neovim tree-sitter-cli ripgrep fd gcc
```

---

### Step 2: Install Language Servers

1. Open Neovim:
```sh
nvim
```

2. Run the Mason install command:
```vim
:MasonInstall ansible-language-server bash-language-server basedpyright css-lsp dockerfile-language-server gopls html-lsp json-lsp marksman ruff rust-analyzer taplo terraform-ls typescript-language-server yaml-language-server
```

3. Mason downloads and installs the server binaries into `~/.local/share/nvim/mason/bin/`.

---

### Step 3: Install Tree-sitter Parsers

Tree-sitter parsers install automatically when Neovim starts via [`lua/treesitter.lua`](./lua/treesitter.lua).

To manually update or install parsers, use:

```vim
:lua require("nvim-treesitter").install(require("treesitter").ensure_installed)
```

---

## LSP Configuration Details

- **Capabilities**: Completion capabilities connect automatically to `mini.completion` in [`lua/lsp.lua`](./lua/lsp.lua).
- **YAML & SchemaStore**: `yamlls` uses `b0o/SchemaStore.nvim` to automatically validate and autocomplete Kubernetes manifests, GitHub Actions workflows, Docker Compose, and ~600 other formats.
- **Python**: `basedpyright` provides hover and type information. `ruff` provides linting and code actions. The hover provider in `ruff` is disabled to prevent duplicate popups.
- **Formatting**: `<leader>f` formats the active buffer or selection using `conform.nvim` with dedicated formatters (`prettier` for Markdown/JSON/YAML, `stylua` for Lua, `shfmt` for Shell, `ruff` for Python) and automatic fallback to active LSP.
