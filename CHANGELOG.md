# Changelog

All notable changes to the `scvim` project are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### 2026-09-01

#### Added
- Added cursor position restoration upon reopening files (`BufReadPost`).
- Added terminal buffer auto-close on clean process exit (`TermClose`).
- Added floating terminal toggle (`<leader>tf`) with clean rounded borders and persistent shell buffer.
- Added wrap-aware vertical navigation for `j` and `k`.
- Added diagnostic jumping keymaps (`[d` / `]d`) and line diagnostic float (`<leader>cd`).
- Added Git hunk navigation (`[h` / `]h`), hunk staging (`<leader>ghs` / `<leader>hs`), overlay diff preview (`<leader>ghp` / `<leader>hp`), and git blame at cursor (`<leader>ghb` / `<leader>gb` / `<leader>hb`).
- Enabled `mini.trailspace` with whitespace trimming keymap (`<leader>cw`).
- Enabled `mini.cursorword` for automatic cursor word highlighting.
- Enabled `mini.indentscope` for subtle active block indentation guides.
- Added `diffopt:append("linematch:60")` for improved diff display accuracy.
- Configured rounded borders across all LSP floating windows (hover, signature help, diagnostics) without deprecated APIs.
- Added single-character black hole delete (`x -> "_x"`) to protect clipboard registers.
- Added relative file path yank keymap (`<leader>yr`).
- Added window split and zoom management (`<leader>s`): vertical split (`<leader>sv`), horizontal split (`<leader>sh`), equalize splits (`<leader>se`), close split (`<leader>sx`), and toggle maximize/zoom (`<leader>sz` / `<leader>sm` via `mini.misc`).
- Integrated `mini.misc` for native window zooming without extra external plugins.
- Configured `mini.trailspace` to unhighlight on cursor movement for subtle whitespace feedback.
- Added dynamic `+language` group architecture (`<leader>l`) for context-aware, filetype-specific actions with zero menu clutter in other languages.
- Added buffer-local Python actions under `<leader>l`: run script (`<leader>lr` via `uv run %`), run test suite (`<leader>lt` via `uv run pytest`), run active file tests (`<leader>lT`), interactive REPL (`<leader>li` via `uv run python`), insert PEP 723 inline script metadata block header (`<leader>lm`), and sync dependencies (`<leader>ls` via `uv sync --script %`).
- Added automatic PEP 723 and `uv` virtual environment resolution to `basedpyright` LSP configuration (`lua/lsp.lua`), dynamically detecting and linking script-specific cached environments to eliminate unresolved import diagnostics without manual `.venv` creation.
- Added buffer-local Go actions under `<leader>l`: run package (`<leader>lr` via `go run .`), run all tests (`<leader>lt` via `go test ./...`), run package tests (`<leader>lT`), module tidy (`<leader>lm`), generate (`<leader>lg`), and vet (`<leader>lv`).
- Added buffer-local Markdown actions under `<leader>l`: task checkbox toggling (`<leader>lx`), preview toggle (`<leader>lp`), bullet lists (`<leader>lb`), and heading level setters (`<leader>l1`–`<leader>l6`).
- Updated `mini.clue` leader descriptions for `+code`, `+git`, `+language/local`, and `+split/substitute`.

### 2026-08-31

#### Added
- Initialized minimal Neovim configuration using native `vim.pack` package management.
- Added side-by-side installation instructions using `NVIM_APPNAME=scvim` in `README.md`.
- Integrated `MeanderingProgrammer/render-markdown.nvim` for in-buffer Markdown preview.
- Integrated `mini.icons` for file, statusline, picker, and Markdown icons.
- Added `<leader>t` toggle keymaps for word wrap (`<leader>tw`), relative numbers (`<leader>tr`), line numbers (`<leader>tn`), LSP diagnostics (`<leader>td`), spell checking (`<leader>ts`), and Markdown rendering (`<leader>tm`).
- Integrated `mini.clue` for interactive keymap hints on `<Leader>`, `g`, `z`, and window commands.
- Added `mini.statusline` configured for global statusline mode (`laststatus = 3`).
- Added `mini.pairs` for automatic bracket and quote management.
- Added `mini.diff` and `mini.git` for real-time gutter diff signs and Git tracking.
- Added `mini.ai` for syntax-aware text objects (functions, arguments, indentation scopes).
- Added `mini.splitjoin` with `gS` mapping to switch between single-line and multi-line structures.
- Added `mini.files`, `mini.pick`, and `mini.extra` for file exploration and fuzzy search.
- Added fuzzy picker keymaps for live grep (`<leader>pg`), open buffers (`<leader>pb`), and recent files (`<leader>pr`).
- Added `mini.bufremove` with `<leader>bd` (close), `<leader>bD` (force close), `<leader>bo` (close others), and `<leader>ba` (close all) without breaking window layouts.
- Added buffer cycling keymaps (`[b` / `]b`) in `lua/keymaps.lua`.
- Added `mini.completion` and `mini.snippets` with `friendly-snippets`.
- Added LSP configurations for 15 languages with Mason package manager support.
- Configured `yamlls` with `b0o/SchemaStore.nvim` for automatic JSON and YAML schema validation.
- Added Tree-sitter parsers for core languages, documentation formats, and web tools.
- Added `:PackAdd`, `:PackDel`, `:PackClean`, and `:PackUpdate` user commands in `lua/commands.lua`.
- Added dedicated `lua/autocmds.lua` for event triggers:
  - Automatic buffer reload on disk change (`FocusGained`, `BufEnter`).
  - Indentation overrides for YAML, Terraform, and Go.
  - Disabled automatic comment continuation on new line.
  - Text yank highlight feedback.
  - Terminal buffer cleanup and automatic insert mode focus (`TermOpen`).
- Added key mappings for quick-save (`<C-s>`), terminal exit (`<Esc><Esc>`), and file path yanking (`<leader>yp`, `<leader>yn`).
- Added `<leader>q` session keymaps (`<leader>qq` quit, `<leader>qw` save and quit, `<leader>qf` force quit, `<leader>qr` restart).
- Added `<leader>v` system keymaps (`<leader>vm` Mason, `<leader>vh` help, `<leader>vl` messages, `<leader>vk` health check, `<leader>vr` restart).
- Added terminal split keymaps (`<leader>tt` bottom split, `<leader>tv` vertical split).
- Added `<leader>i` information insertion keymaps (`<leader>id` date, `<leader>it` time, `<leader>is` ISO timestamp, `<leader>if` filename, `<leader>ip` filepath, `<leader>iu` UUID v4).
- Added visual mode dot repeat (`.`) across multiple selected lines.
- Integrated `hat0uma/csvview.nvim` for CSV/TSV table rendering with `<leader>tc` toggle and spreadsheet navigation (`<Tab>`, `<Enter>`, `if`, `af`).
- Added `<leader>h` documentation keymaps (`<leader>hc` cheatsheet, `<leader>hr` readme, `<leader>hl` changelog, `<leader>hk` languages matrix, `<leader>hh` help tags).
- Integrated `stevearc/conform.nvim` with `<leader>f` for universal buffer and selection formatting (`prettier`, `stylua`, `shfmt`, `ruff`) with automatic LSP fallback.
- Added `mini.comment` integration and keymaps for commenting (`<leader>/` toggle, `gco` line below, `gcO` line above, `gcA` end of line).
- Added reference tables in `CHEATSHEET.md` for essential built-in commands (jump history, window management, and text operations).
- Added documentation in Simplified Technical English: `README.md`, `CHEATSHEET.md`, `LANGUAGES.md`, and `CHANGELOG.md`.

#### Changed
- Refactored all Lua configuration files (`options`, `keymaps`, `autocmds`, `commands`, `pack`, `lsp`, `treesitter`, `init`) into categorized, commented sections.
- Reordered `mini.icons` initialization in `lua/pack.lua` to load early for all UI components.
- Standardized inline code comments and explanations across the entire codebase.
