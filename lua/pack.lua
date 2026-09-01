-- ── 1. Plugin Declarations (vim.pack) ─────────────────────────────────────
vim.pack.add({
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    "https://github.com/b0o/SchemaStore.nvim",
    "https://github.com/hat0uma/csvview.nvim",
    "https://github.com/stevearc/conform.nvim",
})

-- ── 2. Icons Provider (mini.icons) ────────────────────────────────────────
-- Load icons early so pickers, statusline, and markdown can access them
require("mini.icons").setup()

-- ── 3. File Explorer (mini.files) ─────────────────────────────────────────
local MiniFiles = require("mini.files")
MiniFiles.setup({
    mappings = {
        go_in = "<CR>",
        go_in_plus = "L",
        go_out = "_",
        go_out_plus = "H",
    },
})
vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini files explorer" })
vim.keymap.set("n", "<leader>-", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
end, { desc = "Toggle into currently opened file" })

-- ── 4. Fuzzy Pickers (mini.pick & mini.extra) ─────────────────────────────
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")
MiniPick.setup()
MiniExtra.setup()

vim.keymap.set("n", "<leader>pf", function() MiniPick.builtin.files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>pg", function() MiniPick.builtin.grep_live() end, { desc = "Live grep project" })
vim.keymap.set("n", "<leader>ps", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end,
    { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>pb", function() MiniPick.builtin.buffers() end, { desc = "Search open buffers" })
vim.keymap.set("n", "<leader>pr", function() MiniExtra.pickers.oldfiles() end, { desc = "Search recent files" })
vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = "Search keymaps" })
vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Neovim help tags" })

-- ── 5. Keymap Hints (mini.clue) ───────────────────────────────────────────
local miniclue = require("mini.clue")
miniclue.setup({
    triggers = {
        -- Leader triggers
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },

        -- Built-in key triggers
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
        { mode = "n", keys = "<C-w>" },
        { mode = "n", keys = "]" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },
    },
    clues = {
        -- Built-in helper generators
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.z(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),

        -- Custom descriptions for <Leader> subgroups
        { mode = "n", keys = "<Leader>b", desc = "+buffer" },
        { mode = "n", keys = "<Leader>h", desc = "+help/docs" },
        { mode = "n", keys = "<Leader>i", desc = "+insert" },
        { mode = "n", keys = "<Leader>p", desc = "+picker" },
        { mode = "n", keys = "<Leader>q", desc = "+quit/session" },
        { mode = "n", keys = "<Leader>t", desc = "+toggle" },
        { mode = "n", keys = "<Leader>v", desc = "+vim/system" },
        { mode = "n", keys = "<Leader>y", desc = "+yank" },
    },
    window = {
        delay = 300, -- Delay before popup opens (in ms)
        config = {
            width = "auto",
            border = "rounded",
        },
    },
})

-- ── 6. Buffer Management (mini.bufremove) ─────────────────────────────────
local bufremove = require("mini.bufremove")
bufremove.setup()

vim.keymap.set("n", "<leader>bd", function() bufremove.delete(0, false) end, { desc = "Close buffer" })
vim.keymap.set("n", "<leader>bD", function() bufremove.delete(0, true) end,  { desc = "Force close buffer" })

-- Close all buffers except the active one
vim.keymap.set("n", "<leader>bo", function()
    local current = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
            bufremove.delete(buf, false)
        end
    end
end, { desc = "Close other buffers" })

-- Close all open listed buffers
vim.keymap.set("n", "<leader>ba", function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
            bufremove.delete(buf, false)
        end
    end
end, { desc = "Close all buffers" })

-- ── 7. Statusline & UI Components ─────────────────────────────────────────
local statusline = require("mini.statusline")
statusline.setup({
    use_icons = true,
})

require("mini.notify").setup({
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})

require("mini.cmdline").setup()

-- ── 8. Text Objects & Editing ─────────────────────────────────────────────
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.splitjoin").setup()
require("mini.comment").setup()

-- mini.ai provides extended text objects:
-- vif / vaf (function), via / vaa (argument), vii / vai (indentation)
require("mini.ai").setup()

-- ── 9. Markdown Rendering ─────────────────────────────────────────────────
require("render-markdown").setup({
    render_modes = { "n", "c" }, -- Render in Normal and Command mode; raw in Insert mode
    heading = {
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    code = {
        language_name = true,
        width = "full",
    },
    checkbox = {
        unchecked = { icon = "󰄱 " },
        checked   = { icon = "󰱒 " },
    },
})

-- ── 10. CSV & TSV Table Viewer (csvview.nvim) ─────────────────────────────
require("csvview").setup({
    parser = {
        comments = { "#", "//" },
    },
    keymaps = {
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        jump_next_field_end    = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end    = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row          = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row          = { "<S-Enter>", mode = { "n", "v" } },
    },
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Enable csvview for CSV and TSV files",
    pattern = { "csv", "tsv" },
    callback = function(args)
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
                vim.cmd.CsvViewEnable()
            end
        end)
    end,
})

-- ── 11. Code Formatting (conform.nvim) ────────────────────────────────────
local conform = require("conform")
conform.setup({
    formatters_by_ft = {
        lua              = { "stylua" },
        python           = { "ruff_format", "ruff_fix" },
        go               = { "goimports", "gofmt" },
        sh               = { "shfmt" },
        bash             = { "shfmt" },
        terraform        = { "terraform_fmt" },
        tf               = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        yaml             = { "prettier" },
        json             = { "prettier" },
        jsonc            = { "prettier" },
        markdown         = { "prettier" },
        html             = { "prettier" },
        css              = { "prettier" },
        javascript       = { "prettier" },
        javascriptreact  = { "prettier" },
        typescript       = { "prettier" },
        typescriptreact  = { "prettier" },
    },
})

-- Format buffer or visual selection (falls back to active LSP if no CLI tool)
vim.keymap.set({ "n", "v" }, "<leader>f", function()
    conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer or selection" })

-- ── 12. Git Integration ───────────────────────────────────────────────────
require("mini.diff").setup()
require("mini.git").setup()

-- ── 13. Autocompletion & Snippets ─────────────────────────────────────────
local MiniCompletion = require("mini.completion")
MiniCompletion.setup({
    lsp_completion = {
        auto_setup = true,
        process_items = function(items, base)
            return MiniCompletion.default_process_items(items, base, {
                filtersort = "fuzzy",
            })
        end,
    },
})

local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({
    snippets = {
        MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets automatically
    },
    expand = {
        insert = function(snippet)
            MiniSnippets.default_insert(snippet, { empty_tabstop = "" })
        end,
    },
})
MiniSnippets.start_lsp_server({ match = false })

-- ── 14. Syntax & LSP Loaders ──────────────────────────────────────────────
require("treesitter")
require("lsp")
