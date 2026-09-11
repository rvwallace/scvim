# Keymap Cheatsheet

Leader key is set to `<Space>`.

## General Operations

| Keymap       | Mode                   | Description                                |
| :----------- | :--------------------- | :----------------------------------------- |
| `<C-s>`      | Normal, Insert, Visual | Save current file (`:w`).                  |
| `<leader>/`  | Normal, Visual         | Toggle line or selection comment.          |
| `<leader>u`  | Normal                 | Toggle builtin Undotree.                   |
| `<leader>X`  | Normal                 | Make current file executable (`chmod +x`). |
| `<C-c>`      | Normal                 | Clear search highlights.                   |
| `<C-c>`      | Insert                 | Exit insert mode.                          |
| `<Esc><Esc>` | Terminal               | Exit terminal mode.                        |

## Windows (`<leader>w`)

| Keymap       | Mode   | Description                                            |
| :----------- | :----- | :----------------------------------------------------- |
| `<leader>wv` | Normal | Split active window vertically (`<C-w>v`).             |
| `<leader>wh` | Normal | Split active window horizontally (`<C-w>s`).           |
| `<leader>we` | Normal | Equalize size of all open split windows (`<C-w>=`).    |
| `<leader>wz` | Normal | Toggle zoom/maximize active split (`mini.misc`).      |
| `<leader>wx` | Normal | Close current split window (`:close`).                |

## Search and Replace (`<leader>s`)

| Keymap       | Mode   | Description                                  |
| :----------- | :----- | :------------------------------------------- |
| `<leader>sf` | Normal | Search the word under the cursor forward (`*`). |
| `<leader>sb` | Normal | Search the word under the cursor backward (`#`). |
| `<leader>ss` | Normal | Substitute the word under the cursor globally.  |

## Quit and Session (`<leader>q`)

| Keymap       | Mode   | Description                                          |
| :----------- | :----- | :--------------------------------------------------- |
| `<leader>qq` | Normal | Quit all windows and prompt to save unsaved buffers. |
| `<leader>qw` | Normal | Save all buffers and quit (`:xa`).                   |
| `<leader>qf` | Normal | Force quit all windows without saving (`:qa!`).      |
| `<leader>qr` | Normal | Restart Neovim session (`:restart`).                 |

## Vim and System (`<leader>v`)

| Keymap       | Mode   | Description                                                  |
| :----------- | :----- | :----------------------------------------------------------- |
| `<leader>vm` | Normal | Open Mason package manager UI.                               |
| `<leader>vh` | Normal | Search Neovim help documentation tags.                       |
| `<leader>vl` | Normal | View recent notifications and message history (`:messages`). |
| `<leader>vk` | Normal | Run Neovim health checks (`:checkhealth`).                   |
| `<leader>vr` | Normal | Restart Neovim session (`:restart`).                         |

## Fresh Installation Commands

| Command | Description |
| :--- | :--- |
| `:SCInstallAll` | Install all configured Mason tools and Tree-sitter parsers. |
| `:SCMasonInstallAll` | Install configured Mason LSP servers and formatters. |
| `:SCTreesitterInstallAll` | Install configured Tree-sitter parsers. |

## Help and Documentation (`<leader>h`)

| Keymap       | Mode   | Description                                           |
| :----------- | :----- | :---------------------------------------------------- |
| `<leader>hc` | Normal | Open keymap reference cheatsheet (`CHEATSHEET.md`).   |
| `<leader>hr` | Normal | Open project guide and overview (`README.md`).        |
| `<leader>hl` | Normal | Open version changelog history (`CHANGELOG.md`).      |
| `<leader>hk` | Normal | Open language LSP and parser matrix (`LANGUAGES.md`). |
| `<leader>hh` | Normal | Search Neovim help documentation tags (`:help`).      |

## Dynamic Language Actions (`<leader>l`)

*Context-aware keymaps that only activate and show in `mini.clue` for specific filetypes.*

### Python (`FileType python`, uv-native)

| Keymap       | Mode   | Description                                                     |
| :----------- | :----- | :-------------------------------------------------------------- |
| `<leader>lr` | Normal | Run active script via `uv run %` in terminal split.             |
| `<leader>lt` | Normal | Run test suite via `uv run pytest` in terminal split.           |
| `<leader>lT` | Normal | Run tests in active file via `uv run pytest %` in split.        |
| `<leader>li` | Normal | Launch interactive Python REPL via `uv run python` in split.    |
| `<leader>lm` | Normal | Insert PEP 723 inline script metadata header block.             |
| `<leader>ls` | Normal | Sync script dependencies via `uv sync --script %` & reload LSP. |

### Go (`FileType go`)

| Keymap       | Mode   | Description                                                     |
| :----------- | :----- | :-------------------------------------------------------------- |
| `<leader>lr` | Normal | Run active package via `go run .` in terminal split.            |
| `<leader>lt` | Normal | Run all workspace tests via `go test ./...` in terminal split.  |
| `<leader>lT` | Normal | Run verbose tests for active package via `go test -v .`         |
| `<leader>lm` | Normal | Clean and update module dependencies via `go mod tidy`.         |
| `<leader>lg` | Normal | Run code generators via `go generate ./...`.                    |
| `<leader>lv` | Normal | Run static analysis vet checks via `go vet ./...`.              |

### Swift (`FileType swift`)

| Keymap       | Mode   | Description                                                     |
| :----------- | :----- | :-------------------------------------------------------------- |
| `<leader>lr` | Normal | Run active package via `swift run` in terminal split.           |
| `<leader>lb` | Normal | Build active package via `swift build` in terminal split.       |
| `<leader>lt` | Normal | Run test suite via `swift test` in terminal split.              |
| `<leader>lp` | Normal | Resolve package dependencies via `swift package resolve`.       |

### Shell / Bash / Zsh (`FileType sh, bash, zsh`)

| Keymap       | Mode   | Description                                                     |
| :----------- | :----- | :-------------------------------------------------------------- |
| `<leader>lr` | Normal | Run active script in terminal split (`bash %` or `zsh %`).      |
| `<leader>lx` | Normal | Make executable and run immediately (`chmod +x && ./%`).       |
| `<leader>lc` | Normal | Dry-run syntax check (`bash -n` / `zsh -n`) with feedback.      |
| `<leader>ls` | Normal | Run ShellCheck static analysis (`shellcheck %`).                |

### Markdown (`FileType markdown`)

| Keymap                     | Mode           | Description                                       |
| :------------------------- | :------------- | :------------------------------------------------ |
| `<leader>lx`               | Normal, Visual | Toggle task checkbox (`[ ]` ↔ `[x]`).             |
| `<leader>lp`               | Normal         | Toggle Markdown preview rendering.                |
| `<leader>lo`               | Normal         | Open the current note in Obsidian.                |
| `<leader>lb`               | Normal         | Toggle bullet list item (`- `).                   |
| `<leader>l1`–`<leader>l6`  | Normal         | Toggle / set heading levels (`# ` through `###### `). |

## Options and Toggles (`<leader>o`)

| Keymap       | Mode   | Description                                       |
| :----------- | :----- | :------------------------------------------------ |
| `<leader>oc` | Normal | Toggle CSV and TSV table view (`:CsvViewToggle`). |
| `<leader>od` | Normal | Toggle inline LSP diagnostics.                   |
| `<leader>og` | Normal | Toggle Git diff gutter signs (`mini.diff`).      |
| `<leader>om` | Normal | Toggle Markdown preview rendering.              |
| `<leader>on` | Normal | Toggle line numbers.                             |
| `<leader>or` | Normal | Toggle relative line numbers.                   |
| `<leader>os` | Normal | Toggle spell check highlighting.                 |
| `<leader>ow` | Normal | Toggle word wrap.                                |

## Terminals (`<leader>t`)

| Keymap       | Mode   | Description                                |
| :----------- | :----- | :----------------------------------------- |
| `<leader>tf` | Normal | Toggle floating terminal scratchpad.       |
| `<leader>tt` | Normal | Open bottom terminal split.                |
| `<leader>tv` | Normal | Open vertical terminal split on the right. |

## Insert Information (`<leader>i`)

| Keymap       | Mode   | Description                                   |
| :----------- | :----- | :-------------------------------------------- |
| `<leader>id` | Normal | Insert current date (`YYYY-MM-DD`).           |
| `<leader>it` | Normal | Insert current time (`HH:MM:SS`).             |
| `<leader>is` | Normal | Insert ISO timestamp (`YYYY-MM-DDTHH:MM:SS`). |
| `<leader>if` | Normal | Insert active file name.                      |
| `<leader>ip` | Normal | Insert full active file path.                 |
| `<leader>iu` | Normal | Insert random UUID v4 string.                 |

## Clipboard and Delete

| Keymap       | Mode           | Description                                       |
| :----------- | :------------- | :------------------------------------------------ |
| `x`          | Normal         | Delete single character without copying (`"_x`).  |
| `<leader>d`  | Normal, Visual | Delete text without copying to clipboard (`"_d`). |
| `p`          | Visual         | Paste text without replacing register (`"_dP`).   |
| `<leader>yp` | Normal         | Copy absolute file path to system clipboard.      |
| `<leader>yr` | Normal         | Copy relative file path to system clipboard.      |
| `<leader>yn` | Normal         | Copy file name to system clipboard.               |

## Navigation and Movement

| Keymap             | Mode   | Description                                                   |
| :----------------- | :----- | :------------------------------------------------------------ |
| `j` / `k`          | Normal | Wrap-aware vertical navigation (moves visual line if no count)|
| `<C-d>`            | Normal | Scroll down half page and center cursor (`zz`).               |
| `<C-u>`            | Normal | Scroll up half page and center cursor (`zz`).                 |
| `n`                | Normal | Jump to next search match and center cursor.                  |
| `N`                | Normal | Jump to previous search match and center cursor.              |
| `J`                | Normal | Join lines and preserve cursor position.                      |
| `.`                | Visual | Repeat last normal mode edit across every selected line.      |
| `J`                | Visual | Move selected lines down.                                     |
| `K`                | Visual | Move selected lines up.                                       |
| `<M-j>` / `<M-k>`  | Normal, Visual | Move line or selection down / up (`mini.move`).               |
| `<M-h>` / `<M-l>`  | Normal, Visual | Shift line or selection left / right (`mini.move`).              |
| `<`                | Visual | Unindent selection and keep visual mode.                      |
| `>`                | Visual | Indent selection and keep visual mode.                        |
| `<C-^>` or `<C-6>` | Normal | Toggle between active buffer and alternate (previous) buffer. |
| `[b` / `]b`        | Normal | Jump to previous / next open buffer.                          |
| `[d` / `]d`        | Normal | Jump to previous / next diagnostic error/warning.             |

## Jump History and Context

| Keymap | Mode | Description |
| :--- | :--- | :--- |
| `<C-o>` | Normal | Jump backward in cursor jump history. |
| `<C-i>` | Normal | Jump forward in cursor jump history. |
| `gi` | Normal | Jump to last edit location and enter insert mode. |
| `gv` | Normal | Reselect previous visual selection. |
| `gf` | Normal | Open file path under cursor. |
| `gx` | Normal | Open URL or link under cursor in system browser. |
| `g;` | Normal | Jump to previous change location (`:changes`). |
| `g,` | Normal | Jump to next change location (`:changes`). |

## Window and Split Management

| Keymap | Mode | Description |
| :--- | :--- | :--- |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Normal | Directly focus left / down / up / right split window. |
| `<C-Up>` / `<C-Down>` | Normal | Increase / decrease split window height (`:resize ±2`). |
| `<C-Left>` / `<C-Right>` | Normal | Decrease / increase split window width (`:vertical resize ±2`). |
| `<C-w>v` | Normal | Open vertical split window. |
| `<C-w>s` | Normal | Open horizontal split window. |
| `<C-w>o` | Normal | Maximize active split and close all other windows (`:only`). |
| `<C-w>=` | Normal | Equalize size of all open split windows. |
| `<C-w>T` | Normal | Move active split window into its own new Tab page. |
| `<C-w>x` | Normal | Exchange active split window with adjacent neighbor. |
| `<C-w>q` | Normal | Close active split window (`:close`). |
| `<C-w>h/j/k/l` | Normal | Move cursor focus to left / down / up / right window. |

## Quick Operations and Casing

| Keymap | Mode | Description |
| :--- | :--- | :--- |
| `ZZ` | Normal | Save active file and quit window (`:x`). |
| `ZQ` | Normal | Force quit active window without saving (`:q!`). |
| `gUiw` | Normal | Convert word under cursor to uppercase. |
| `guiw` | Normal | Convert word under cursor to lowercase. |
| `*` | Normal | Search forward for exact match of word under cursor. |
| `#` | Normal | Search backward for exact match of word under cursor. |
| `C` | Normal | Change from cursor to end of line (`c$`). |
| `D` | Normal | Delete from cursor to end of line (`d$`). |

## Buffer Management (`mini.bufremove`)

| Keymap             | Mode   | Description                                                   |
| :----------------- | :----- | :------------------------------------------------------------ |
| `<C-^>` or `<C-6>` | Normal | Toggle between active buffer and alternate (previous) buffer. |
| `<leader>bd`       | Normal | Close active buffer and preserve window splits.               |
| `<leader>bD`       | Normal | Force close active buffer without saving.                     |
| `<leader>bo`       | Normal | Close all other buffers except the active buffer.             |
| `<leader>ba`       | Normal | Close all open buffers.                                       |
| `<leader>pb`       | Normal | Search open buffers with fuzzy picker.                        |

## File Explorer (`mini.files`)

| Keymap        | Mode     | Description                               |
| :------------ | :------- | :---------------------------------------- |
| `-`           | Normal   | Open file explorer.                       |
| `<leader>-`   | Normal   | Open file explorer at active buffer path. |
| `<CR>` or `L` | Explorer | Enter directory or open file.             |
| `_` or `H`    | Explorer | Go up to parent directory.                |
| `g.` or `.`   | Explorer | Toggle hidden files (dotfiles).           |

## Pickers and Search (`mini.pick` & `mini.extra`)

| Keymap       | Mode   | Description                                          |
| :----------- | :----- | :--------------------------------------------------- |
| `<leader>pf` | Normal | Find files in workspace (includes hidden files when supported). |
| `<leader>pg` | Normal | Search workspace interactively (includes hidden files with ripgrep). |
| `<leader>ps` | Normal | Search word under cursor (includes hidden files with ripgrep). |
| `<leader>pb` | Normal | Search open buffers.                        |
| `<leader>pr` | Normal | Search recently opened files (`oldfiles`).  |
| `<leader>pk` | Normal | Search active keymaps.                      |
| `<leader>vh` | Normal | Search Neovim help tags.                    |
| `<leader>xx` | Normal | Search workspace diagnostics.               |

## Text Objects and Editing (`mini.ai`, `mini.pairs` & `treesj`)

| Keymap        | Mode   | Description                                                     |
| :------------ | :----- | :-------------------------------------------------------------- |
| `gS`          | Normal | Toggle a code structure between split and joined forms (`treesj`). |
| `<leader>cs`  | Normal | Split the code structure under the cursor (`treesj`).             |
| `<leader>cj`  | Normal | Join the code structure under the cursor (`treesj`).              |
| `va)` / `vi)` | Visual | Select around / inside parentheses or brackets.                 |
| `vaf` / `vif` | Visual | Select around / inside function.                                |
| `vaa` / `via` | Visual | Select around / inside parameter or argument.                   |
| `vai` / `vii` | Visual | Select around / inside indentation block.                       |
| `<C-o>A`      | Insert | Jump to end of line in insert mode.                             |

## Code Commenting (`mini.comment`)

| Keymap | Mode | Description |
| :--- | :--- | :--- |
| `<leader>/` | Normal, Visual | Toggle line or selection comment. |
| `gcc` | Normal | Toggle line comment. |
| `gc` | Visual | Toggle selection comment. |
| `gbc` | Normal | Toggle block comment on current line. |
| `gb` | Visual | Toggle block comment around visual selection. |
| `gco` | Normal | Insert comment line below cursor. |
| `gcO` | Normal | Insert comment line above cursor. |
| `gcA` | Normal | Insert comment at end of current line. |

## Surround Motions (`mini.surround`)

| Keymap                       | Mode   | Description                      |
| :--------------------------- | :----- | :------------------------------- |
| `sa` + `{motion}` + `{char}` | Normal | Add surrounding character.       |
| `sd` + `{char}`              | Normal | Delete surrounding character.    |
| `sr` + `{old}` + `{new}`     | Normal | Replace surrounding character.   |
| `sh` + `{char}`              | Normal | Highlight surrounding character. |

## Git and Diffs (`mini.diff`, `mini.git` & `zdiff.nvim`)

| Keymap        | Mode    | Description                                      |
| :------------ | :------ | :----------------------------------------------- |
| `[h`          | Normal  | Jump to previous diff hunk.                      |
| `]h`          | Normal  | Jump to next diff hunk.                          |
| `<leader>ghs` | Normal  | Stage git hunk under cursor (operator).         |
| `<leader>ghp` | Normal  | Toggle inline diff overlay preview.             |
| `<leader>ghb` | Normal  | Show Git blame and commit details at cursor.    |
| `<leader>gz`  | Normal  | Open zdiff multi-buffer git diff viewer.        |
| `gh`          | Normal  | Apply diff hunk under cursor.                    |
| `gH`          | Normal  | Reset diff hunk under cursor.                    |
| `:Git`        | Command | Run Git command in split window.                 |
| `:Zdiff`      | Command | Open multi-buffer diff viewer (optional git ref).|

## LSP and Code Formatting (`conform.nvim`)

| Keymap        | Mode           | Description                                                                  |
| :------------ | :------------- | :--------------------------------------------------------------------------- |
| `gd`          | Normal         | Jump to symbol definition.                                                   |
| `gD`          | Normal         | Jump to symbol declaration.                                                  |
| `gi`          | Normal         | Jump to symbol implementation.                                               |
| `gr`          | Normal         | Search symbol references (`mini.extra` picker).                              |
| `K`           | Normal         | Show hover documentation (native LSP with rounded border).                   |
| `<leader>cr`  | Normal         | Rename symbol across workspace.                                              |
| `<leader>ca`  | Normal         | Open code actions menu.                                                      |
| `<leader>co`  | Normal         | Organize imports (`source.organizeImports`).                                 |
| `<leader>cd`  | Normal         | Show line diagnostics floating window.                                       |
| `<leader>cw`  | Normal         | Trim trailing whitespace in active buffer.                                   |
| `<leader>f`   | Normal, Visual | Format active buffer or visual selection (`conform.nvim` with LSP fallback). |
| `[d` / `]d`   | Normal         | Jump to previous / next diagnostic.                                          |

## Autocompletion and Snippets (`mini.completion` & `mini.snippets`)

| Keymap      | Mode           | Description                                    |
| :---------- | :------------- | :--------------------------------------------- |
| `<C-Space>` | Insert         | Manually trigger two-step completion popup.    |
| `<C-j>`     | Insert         | Directly expand snippet prefix under cursor.   |
| `<C-n>`     | Insert         | Next completion item.                          |
| `<C-p>`     | Insert         | Previous completion item.                      |
| `<C-l>`     | Insert, Select | Jump to next snippet tabstop.                  |
| `<C-h>`     | Insert, Select | Jump to previous snippet tabstop.              |
| `<Tab>` / `<S-Tab>` | Insert | Move out of surrounding brackets or quotes (`tabout.nvim`). |

*Custom snippets are organized in the [`snippets/`](./snippets/) directory (e.g. `global.json`, `python.json`, `sh.json`).*

## CSV Table Navigation (`csvview.nvim`)

| Keymap      | Mode             | Description                            |
| :---------- | :--------------- | :------------------------------------- |
| `<Tab>`     | Normal, Visual   | Jump to next field in CSV row.         |
| `<S-Tab>`   | Normal, Visual   | Jump to previous field in CSV row.     |
| `<Enter>`   | Normal, Visual   | Jump to next row in same column.       |
| `<S-Enter>` | Normal, Visual   | Jump to previous row in same column.   |
| `if`        | Operator, Visual | Select inner CSV cell content.         |
| `af`        | Operator, Visual | Select around CSV cell with delimiter. |
