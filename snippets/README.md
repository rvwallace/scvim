# Snippets Guide & Architecture

`scvim` uses **`mini.snippets`** loaded with **VS Code-compatible JSON snippets**. It merges community snippets from **`friendly-snippets`** with custom user snippets stored directly in this directory.

---

## 📁 File Structure & Language Mapping

Snippet files follow the standard VS Code JSON naming convention matching Neovim's `&filetype`:

| File | Filetypes & Aliases | Example Triggers |
| :--- | :--- | :--- |
| **`global.json`** | All buffers | `#!bash`, `#!zsh`, `#!uv`, `#!python`, `#!swift`, `#!node` |
| **`python.json`** | `python` | `pep723`, `pep723-typer`, `pep723-rich`, `dataclass`, `xdg-dir` |
| **`sh.json`** | `sh`, `bash`, `zsh` | `script`, `sh-script`, `zsh-function`, `parse-args`, `tmpfile`, `die` |
| **`go.json`** | `go` | `cli-subcommands`, `bubbletea`, `ifew` |
| **`swift.json`** | `swift` | `script`, `shell-cmd` |
| **`terraform.json`** | `terraform`, `hcl` | `var`, `output`, `backend-s3`, `dynamic` |
| **`markdown.json`** | `markdown` | `frontmatter`, `callout` |

---

## ✍️ VS Code JSON Format Specification

All snippets in this directory use standard VS Code JSON format:

```json
{
  "Descriptive Snippet Name": {
    "prefix": ["trigger1", "trigger2"],
    "body": [
      "def ${1:function_name}(${2:arg}: ${3:str}) -> ${4:None}:",
      "    \"\"\"${5:Docstring.}\"\"\"",
      "    ${0:pass}"
    ],
    "description": "Short explanation shown in completion menu"
  }
}
```

### Syntax Elements

- **`${1:default}`**: Placeholder tabstop with default text.
- **`${2}`**: Plain tabstop without default text.
- **`${1|apple,banana,cherry|}`**: Choice tabstop allowing selection from a list.
- **`$1` (repeated)**: Mirrored tabstop. Editing `${1:name}` updates all `$1` references simultaneously.
- **`${0}`**: Final cursor position after completing all tabstops.
- **`\t`**: Hard tab (auto-indents to buffer shiftwidth).

> [!IMPORTANT]
> **Escaping Literal Dollar Signs in Shell / HCL / Scripts**:
> In snippet syntax, `$` denotes a placeholder. To insert a literal shell variable like `${BASH_SOURCE[0]}` or `$@`, escape the dollar sign as `\${BASH_SOURCE[0]}` and `\$@`. Unescaped variables will cause the snippet parser to abort.

---

## ⚙️ How `scvim`'s Custom Loader Works

`scvim` includes a custom loader in `lua/pack.lua` that enhances `mini.snippets` to ensure seamless compatibility with VS Code JSON files:

1. **Multi-Prefix Flattening**: In VS Code format, `"prefix"` can be an array (`["script", "sh-script"]`). The loader splits array prefixes into individual string entries so every alias matches accurately.
2. **LSP Multiline Joining**: Converts JSON `body` arrays into newline-joined string blocks required by Neovim's LSP completion engine.
3. **Filetype Alias Resolution**: Automatically resolves language mismatches between Neovim filetypes and Tree-sitter grammars (e.g. `sh` ↔ `bash` ↔ `zsh`, `terraform` ↔ `hcl`).
4. **Clean Tabstops**: Disables visual placeholder artifacts (`∎` / `•`) so the cursor lands cleanly at each tabstop without corrupting the buffer.

---

## ⌨️ Snippet Controls & Keybindings

| Keymap | Mode | Action |
| :--- | :--- | :--- |
| **`<C-j>`** | Insert | **Expand snippet prefix under cursor immediately** |
| `<C-Space>` | Insert | Open autocompletion popup (shows `[Snippet]` items) |
| `<C-n>` / `<C-p>` | Insert | Navigate completion candidates |
| `<Enter>` / `<C-y>` | Insert | Confirm selection and expand snippet |
| **`<C-l>`** | Insert, Select | **Jump forward to next tabstop** |
| **`<C-h>`** | Insert, Select | **Jump backward to previous tabstop** |

---

## 🧪 Testing & Validation

To verify that all snippet JSON files are syntax-valid and load without errors, run:

```sh
NVIM_APPNAME=scvim nvim --headless -c "lua local s = require('mini.snippets'); local langs = {'global', 'python', 'sh', 'go', 'swift'}; for _, l in ipairs(langs) do local file = vim.fn.stdpath('config') .. '/snippets/' .. l .. '.json'; local snips = s.read_file(file); for _, sn in ipairs(snips or {}) do local body = type(sn.body) == 'table' and table.concat(sn.body, '\n') or sn.body; assert(pcall(s.parse, body)) end end; print('✓ ALL SNIPPETS VALID'); vim.cmd('qa!')"
```
