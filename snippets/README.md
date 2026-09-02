# Snippets Guide & Management

`scvim` uses **`mini.snippets`** to manage snippets. It seamlessly combines community snippets from **`friendly-snippets`** with your custom snippets defined in this directory.

---

## 📁 File Structure & Mapping

Files in this directory are matched against Neovim's `&filetype`:

| File | Scope / Filetype | Example Triggers |
| :--- | :--- | :--- |
| **`global.json`** | All buffers & filetypes | `#!bash`, `#!zsh`, `#!uv`, `#!python`, `#!swift`, `#!node` |
| **`python.json`** | `python` | `pep723`, `pep723-typer`, `pep723-rich`, `dataclass`, `xdg-dir` |
| **`sh.json`** | `sh`, `bash`, `zsh` | `script`, `zsh-function`, `parse-args`, `tmpfile`, `die`, `colors` |
| **`go.json`** | `go` | `cli-subcommands`, `bubbletea`, `ifew` |
| **`swift.json`** | `swift` | `script`, `shell-cmd` |
| **`terraform.json`** | `terraform`, `hcl` | `var`, `output`, `backend-s3`, `dynamic` |
| **`markdown.json`** | `markdown` | `frontmatter`, `callout` |

---

## ✍️ Snippet Format Specification

Snippets follow the standard VS Code JSON format:

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
- **`${1|apple,banana,cherry|}`**: Choice tabstop allowing you to pick from a list.
- **`$1` (repeated)**: Mirrored placeholder. When you type in `${1:name}`, every occurrence of `$1` updates simultaneously.
- **`${0}`**: Final cursor position after all tabstops are visited.
- **`\t`**: Hard tab (indentation is adjusted according to buffer settings).

---

## ⌨️ Snippet Controls & Keybindings

| Keymap | Mode | Action |
| :--- | :--- | :--- |
| `<C-Space>` | Insert | Open autocompletion & snippet menu |
| `<C-n>` / `<C-p>` | Insert | Select completion item |
| `<Enter>` / `<C-y>` | Insert | Confirm selection and expand snippet |
| **`<C-l>`** | Insert, Select | **Jump forward to next tabstop** |
| **`<C-h>`** | Insert, Select | **Jump backward to previous tabstop** |

---

## 🧪 Testing & Validation

To test that your snippet files contain valid JSON and load correctly into `mini.snippets`, run this command from the repository root:

```sh
NVIM_APPNAME=scvim nvim --headless -c "lua local s = require('mini.snippets'); local langs = {'global', 'python', 'sh', 'go', 'swift'}; for _, l in ipairs(langs) do local file = vim.fn.stdpath('config') .. '/snippets/' .. l .. '.json'; local snips = s.gen_loader.from_file(file)({ lang = l }); print(l .. ' count: ' .. #snips) end; vim.cmd('qa')"
```
