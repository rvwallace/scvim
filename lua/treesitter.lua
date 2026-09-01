local treesitter = require("nvim-treesitter")

-- ── 1. Parsers to Install ─────────────────────────────────────────────────
-- Parser compilation requires tree-sitter-cli 0.26.1 or later.
-- Install it with your system package manager (e.g. `brew install tree-sitter-cli`).
local ensure_installed = {
    -- Neovim & Internal
    "lua", "vim", "vimdoc", "query",

    -- Core Programming Languages
    "bash",
    "go", "gomod", "gosum", "gowork",
    "python",
    "rust",
    "terraform",
    "javascript", "typescript", "tsx",
    "html", "css",

    -- Config & Documentation Formats
    "dockerfile",
    "json", "json5",
    "markdown", "markdown_inline",
    "toml",
    "yaml",

    -- Utilities
    "http",
}

treesitter.install(ensure_installed)

-- ── 2. Automatic Tree-sitter Highlighting Attachment ──────────────────────
-- Attach Tree-sitter highlighting whenever a buffer with a matching parser opens
vim.api.nvim_create_autocmd("FileType", {
    desc = "Start Tree-sitter highlighting for supported filetypes",
    pattern = "*",
    callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype

        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
            return
        end

        local ok, loaded = pcall(vim.treesitter.language.add, lang)
        if not ok or not loaded then
            return
        end

        vim.treesitter.start(buf, lang)
    end,
})
