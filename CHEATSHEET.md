# Keymap Cheatsheet

Leader key is set to `<Space>`.

## General Operations

| Keymap       | Mode                   | Description                                |
| :----------- | :--------------------- | :----------------------------------------- |
| `<C-s>`      | Normal, Insert, Visual | Save current file (`:w`).                  |
| `<leader>/`  | Normal, Visual         | Toggle line or selection comment.          |
| `<leader>u`  | Normal                 | Toggle builtin Undotree.                   |
| `<leader>X`  | Normal                 | Make current file executable (`chmod +x`). |
| `<leader>s`  | Normal                 | Substitute word under cursor globally.     |
| `<C-c>`      | Normal                 | Clear search highlights.                   |
| `<C-c>`      | Insert                 | Exit insert mode.                          |
| `<Esc><Esc>` | Terminal               | Exit terminal mode.                        |

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

## Help and Documentation (`<leader>h`)

| Keymap       | Mode   | Description                                           |
| :----------- | :----- | :---------------------------------------------------- |
| `<leader>hc` | Normal | Open keymap reference cheatsheet (`CHEATSHEET.md`).   |
| `<leader>hr` | Normal | Open project guide and overview (`README.md`).        |
| `<leader>hl` | Normal | Open version changelog history (`CHANGELOG.md`).      |
| `<leader>hk` | Normal | Open language LSP and parser matrix (`LANGUAGES.md`). |
| `<leader>hh` | Normal | Search Neovim help documentation tags (`:help`).      |

## Quick Toggles and Terminal (`<leader>t`)

| Keymap       | Mode   | Description                                       |
| :----------- | :----- | :------------------------------------------------ |
| `<leader>tt` | Normal | Open bottom terminal split (12 lines high).       |
| `<leader>tv` | Normal | Open vertical terminal split on the right.        |
| `<leader>tc` | Normal | Toggle CSV and TSV table view (`:CsvViewToggle`). |
| `<leader>tw` | Normal | Toggle word wrap.                                 |
| `<leader>tr` | Normal | Toggle relative line numbers.                     |
| `<leader>tn` | Normal | Toggle line numbers.                              |
| `<leader>td` | Normal | Toggle inline LSP diagnostics.                    |
| `<leader>ts` | Normal | Toggle spell check highlighting.                  |
| `<leader>tm` | Normal | Toggle Markdown preview rendering.                |

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
| `<leader>d`  | Normal, Visual | Delete text without copying to clipboard (`"_d`). |
| `p`          | Visual         | Paste text without replacing register (`"_dP`).   |
| `<leader>yp` | Normal         | Copy full file path to system clipboard.          |
| `<leader>yn` | Normal         | Copy file name to system clipboard.               |

## Navigation and Movement

| Keymap             | Mode   | Description                                                   |
| :----------------- | :----- | :------------------------------------------------------------ |
| `<C-d>`            | Normal | Scroll down half page and center cursor (`zz`).               |
| `<C-u>`            | Normal | Scroll up half page and center cursor (`zz`).                 |
| `n`                | Normal | Jump to next search match and center cursor.                  |
| `N`                | Normal | Jump to previous search match and center cursor.              |
| `J`                | Normal | Join lines and preserve cursor position.                      |
| `.`                | Visual | Repeat last normal mode edit across every selected line.      |
| `J`                | Visual | Move selected lines down.                                     |
| `K`                | Visual | Move selected lines up.                                       |
| `<`                | Visual | Unindent selection and keep visual mode.                      |
| `>`                | Visual | Indent selection and keep visual mode.                        |
| `<C-^>` or `<C-6>` | Normal | Toggle between active buffer and alternate (previous) buffer. |
| `[b`               | Normal | Jump to previous buffer.                                      |
| `]b`               | Normal | Jump to next buffer.                                          |

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

## Pickers and Search (`mini.pick` & `mini.extra`)

| Keymap       | Mode   | Description                                 |
| :----------- | :----- | :------------------------------------------ |
| `<leader>pf` | Normal | Find files in workspace.                    |
| `<leader>pg` | Normal | Run live interactive grep across workspace. |
| `<leader>ps` | Normal | Search word under cursor with grep.         |
| `<leader>pb` | Normal | Search open buffers.                        |
| `<leader>pr` | Normal | Search recently opened files (`oldfiles`).  |
| `<leader>pk` | Normal | Search active keymaps.                      |
| `<leader>vh` | Normal | Search Neovim help tags.                    |
| `<leader>xx` | Normal | Search workspace diagnostics.               |

## Text Objects and Editing (`mini.ai` & `mini.pairs`)

| Keymap        | Mode   | Description                                                     |
| :------------ | :----- | :-------------------------------------------------------------- |
| `gS`          | Normal | Toggle single-line and multi-line structure (`mini.splitjoin`). |
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

## Git and Diffs (`mini.diff` & `mini.git`)

| Keymap | Mode    | Description                      |
| :----- | :------ | :------------------------------- |
| `[h`   | Normal  | Jump to previous diff hunk.      |
| `]h`   | Normal  | Jump to next diff hunk.          |
| `gh`   | Normal  | Apply diff hunk under cursor.    |
| `gH`   | Normal  | Reset diff hunk under cursor.    |
| `:Git` | Command | Run Git command in split window. |

## LSP and Code Formatting (`conform.nvim`)

| Keymap      | Mode           | Description                                                                  |
| :---------- | :------------- | :--------------------------------------------------------------------------- |
| `gd`        | Normal         | Jump to symbol definition.                                                   |
| `<leader>f` | Normal, Visual | Format active buffer or visual selection (`conform.nvim` with LSP fallback). |
| `K`         | Normal         | Show hover documentation (native LSP).                                       |
| `[d` / `]d` | Normal         | Jump to previous / next diagnostic (native LSP).                             |

## CSV Table Navigation (`csvview.nvim`)

| Keymap      | Mode             | Description                            |
| :---------- | :--------------- | :------------------------------------- |
| `<Tab>`     | Normal, Visual   | Jump to next field in CSV row.         |
| `<S-Tab>`   | Normal, Visual   | Jump to previous field in CSV row.     |
| `<Enter>`   | Normal, Visual   | Jump to next row in same column.       |
| `<S-Enter>` | Normal, Visual   | Jump to previous row in same column.   |
| `if`        | Operator, Visual | Select inner CSV cell content.         |
| `af`        | Operator, Visual | Select around CSV cell with delimiter. |
