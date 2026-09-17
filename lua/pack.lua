-- ── 1. Plugin Declarations (vim.pack) ─────────────────────────────────────
vim.pack.add({
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/abecodes/tabout.nvim",
    "https://github.com/Wansmer/treesj",
    "https://github.com/rafamadriz/friendly-snippets",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    "https://github.com/b0o/SchemaStore.nvim",
    "https://github.com/hat0uma/csvview.nvim",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/martindur/zdiff.nvim",
})

-- ── 2. Icons Provider (mini.icons) ────────────────────────────────────────
-- Load icons early so pickers, statusline, and markdown can access them
require("mini.icons").setup()

-- ── 3. File Explorer (mini.files) ─────────────────────────────────────────
local MiniFiles = require("mini.files")

local show_dotfiles = false
local filter_show = function(_) return true end
local filter_hide = function(entry) return not vim.startswith(entry.name, ".") end

MiniFiles.setup({
    content = {
        filter = function(entry)
            return show_dotfiles and filter_show(entry) or filter_hide(entry)
        end,
    },
    mappings = {
        go_in = "<CR>",
        go_in_plus = "L",
        go_out = "_",
        go_out_plus = "H",
    },
})

local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show or filter_hide
    MiniFiles.refresh({ content = { filter = new_filter } })
end

vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
        local buf_id = args.data.buf_id
        vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden files" })
        vim.keymap.set("n", ".", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden files" })
    end,
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

local function pick_files()
    local cmd
    if vim.fn.executable("rg") == 1 then
        cmd = { "rg", "--files", "--hidden", "--glob", "!.git/*", "--color=never" }
    elseif vim.fn.executable("fd") == 1 then
        cmd = { "fd", "--type=f", "--hidden", "--exclude", ".git", "--color=never" }
    elseif vim.fn.executable("git") == 1 then
        cmd = { "git", "ls-files", "--cached", "--others", "--exclude-standard" }
    else
        return MiniPick.builtin.files({ tool = "fallback" })
    end

    MiniPick.builtin.cli({ command = cmd }, {
        source = {
            name = "Files",
            show = function(buf_id, items, query)
                MiniPick.default_show(buf_id, items, query, { show_icons = true })
            end,
        },
    })
end

local function pick_grep_live()
    if vim.fn.executable("rg") ~= 1 then
        if vim.fn.executable("git") == 1 then return MiniPick.builtin.grep_live({ tool = "git" }) end
        return MiniPick.builtin.grep({ tool = "fallback" })
    end

    local set_items_opts = { do_match = false }
    local spawn_opts = { cwd = vim.fn.getcwd() }
    local sys = { kill = function() end }
    local match = function(_, _, query)
        sys:kill()
        if #query == 0 then
            sys = { kill = function() end }
            return MiniPick.set_picker_items({}, set_items_opts)
        end
        local case = vim.o.ignorecase and (vim.o.smartcase and "smart-case" or "ignore-case") or "case-sensitive"
        local cmd = {
            "rg",
            "--column",
            "--line-number",
            "--no-heading",
            "--field-match-separator",
            "\\x00",
            "--color=never",
            "--hidden",
            "--glob",
            "!.git/*",
            "--" .. case,
            "--",
            table.concat(query),
        }
        sys = MiniPick.set_picker_items_from_cli(cmd, { set_items_opts = set_items_opts, spawn_opts = spawn_opts })
    end

    MiniPick.start({
        source = {
            name = "Grep Live",
            items = {},
            match = match,
            show = function(buf_id, items, query)
                MiniPick.default_show(buf_id, items, query, { show_icons = true })
            end,
        },
    })
end

local function pick_grep_word()
    local pattern = vim.fn.expand("<cword>")
    if pattern == "" then return end
    if vim.fn.executable("rg") ~= 1 then return MiniPick.builtin.grep({ pattern = pattern }) end

    local case = vim.o.ignorecase and (vim.o.smartcase and "smart-case" or "ignore-case") or "case-sensitive"
    local cmd = {
        "rg",
        "--column",
        "--line-number",
        "--no-heading",
        "--field-match-separator",
        "\\x00",
        "--color=never",
        "--hidden",
        "--glob",
        "!.git/*",
        "--" .. case,
        "--",
        pattern,
    }
    MiniPick.builtin.cli({ command = cmd }, {
        source = {
            name = string.format("Grep (%s)", pattern),
            show = function(buf_id, items, query)
                MiniPick.default_show(buf_id, items, query, { show_icons = true })
            end,
        },
    })
end

vim.keymap.set("n", "<leader>pf", pick_files, { desc = "Find files (including hidden)" })
vim.keymap.set("n", "<leader>pg", pick_grep_live, { desc = "Live grep project (including hidden)" })
vim.keymap.set("n", "<leader>ps", pick_grep_word, { desc = "Grep word under cursor (including hidden)" })
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
        { mode = "n", keys = "<Leader>c", desc = "+code/editing" },
        { mode = "n", keys = "<Leader>g", desc = "+git" },
        { mode = "n", keys = "<Leader>h", desc = "+help/docs" },
        { mode = "n", keys = "<Leader>i", desc = "+insert" },
        { mode = "n", keys = "<Leader>l", desc = "+language/local" },
        { mode = "n", keys = "<Leader>p", desc = "+picker" },
        { mode = "n", keys = "<Leader>q", desc = "+quit/session" },
        { mode = "n", keys = "<Leader>o", desc = "+options/toggles" },
        { mode = "n", keys = "<Leader>s", desc = "+search/replace" },
        { mode = "n", keys = "<Leader>t", desc = "+terminal" },
        { mode = "n", keys = "<Leader>v", desc = "+vim/system" },
        { mode = "n", keys = "<Leader>w", desc = "+window" },
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

-- Git repository stats cache and branch detector
local repo_stats_cache = {}
local last_fetch_time = {}

local function get_git_root(buf_id)
    buf_id = buf_id or 0
    local summary = vim.b[buf_id].minigit_summary
    if summary and summary.root and summary.root ~= "" then
        return summary.root
    end
    local buf_name = vim.api.nvim_buf_get_name(buf_id)
    local start_path = (buf_name ~= "") and vim.fs.dirname(buf_name) or vim.fn.getcwd()
    return vim.fs.root(start_path, ".git")
end

local function get_git_dir(root)
    if not root then return nil end
    local git_path = root .. "/.git"
    local stat = vim.uv.fs_stat(git_path)
    if not stat then return nil end
    if stat.type == "directory" then
        return git_path
    elseif stat.type == "file" then
        local f = io.open(git_path, "r")
        if f then
            local line = f:read("*l") or ""
            f:close()
            local dir = line:match("^gitdir:%s*(.+)$")
            if dir then
                if not dir:match("^/") then dir = root .. "/" .. dir end
                return dir
            end
        end
    end
    return nil
end

local function get_git_branch(buf_id, root)
    buf_id = buf_id or 0
    local summary = vim.b[buf_id].minigit_summary
    if summary and summary.head_name and summary.head_name ~= "" then
        local head = summary.head_name == "HEAD" and (summary.head or ""):sub(1, 7) or summary.head_name
        if summary.in_progress and summary.in_progress ~= "" then
            head = head .. "|" .. summary.in_progress
        end
        return head
    end

    local git_dir = get_git_dir(root)
    if not git_dir then return nil end
    local head_file = git_dir .. "/HEAD"
    local f = io.open(head_file, "r")
    if not f then return nil end
    local line = f:read("*l") or ""
    f:close()
    local branch = line:match("^ref:%s*refs/heads/(.+)$")
    if branch then return branch end
    if #line >= 7 then return line:sub(1, 7) end
    return nil
end

local function update_remote_stats(root)
    if not root or vim.fn.executable("git") ~= 1 then return end
    local now = vim.uv.now()
    if last_fetch_time[root] and (now - last_fetch_time[root] < 5000) then
        return
    end
    last_fetch_time[root] = now

    vim.system(
        { "git", "rev-list", "--left-right", "--count", "HEAD...@{upstream}" },
        { text = true, cwd = root },
        function(res)
            if res.code == 0 and res.stdout then
                local ahead, behind = res.stdout:match("(%d+)%s+(%d+)")
                ahead = tonumber(ahead) or 0
                behind = tonumber(behind) or 0
                local str = ""
                if ahead > 0 and behind > 0 then
                    str = string.format("⇡%d ⇣%d", ahead, behind)
                elseif ahead > 0 then
                    str = string.format("⇡%d", ahead)
                elseif behind > 0 then
                    str = string.format("⇣%d", behind)
                end
                repo_stats_cache[root] = str
            else
                repo_stats_cache[root] = ""
            end
            vim.schedule(function()
                pcall(function() vim.cmd.redrawstatus() end)
            end)
        end
    )
end

local function git_section(args)
    args = args or {}
    local trunc_width = args.trunc_width or 40
    if statusline.is_truncated(trunc_width) then return "" end

    local buf = vim.api.nvim_get_current_buf()
    local root = get_git_root(buf)
    if not root then return "" end

    local branch = get_git_branch(buf, root)
    if not branch or branch == "" then return "" end

    update_remote_stats(root)
    local remote_stats = repo_stats_cache[root] or ""

    local parts = { "", branch }
    if remote_stats ~= "" and not statusline.is_truncated(75) then
        table.insert(parts, remote_stats)
    end
    return table.concat(parts, " ")
end

local function diff_section(args)
    args = args or {}
    local trunc_width = args.trunc_width or 75
    if statusline.is_truncated(trunc_width) then return "" end
    local summary = vim.b.minidiff_summary_string or vim.b.gitsigns_status
    if not summary or summary == "" or summary == "-" then return "" end
    local icon = args.icon or ""
    return icon .. " " .. summary
end

-- Invalidate remote stats cache on window focus, file write, or directory change
local git_status_group = vim.api.nvim_create_augroup("StatuslineGitRefresh", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "BufWritePost", "DirChanged" }, {
    group = git_status_group,
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local root = get_git_root(buf)
        if root then
            last_fetch_time[root] = nil
            update_remote_stats(root)
        end
    end,
})
vim.api.nvim_create_autocmd("User", {
    group = git_status_group,
    pattern = "MiniGitUpdated",
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local root = get_git_root(buf)
        if root then
            last_fetch_time[root] = nil
        end
    end,
})

statusline.setup({
    use_icons = true,
    content = {
        active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local git           = git_section({ trunc_width = 40 })
            local diff          = diff_section({ trunc_width = 75 })
            local diagnostics   = statusline.section_diagnostics({ trunc_width = 75 })
            local lsp           = statusline.section_lsp({ trunc_width = 75 })
            local filename      = statusline.section_filename({ trunc_width = 140 })
            local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
            local location      = statusline.section_location({ trunc_width = 75 })
            local search        = statusline.section_searchcount({ trunc_width = 75 })

            return statusline.combine_groups({
                { hl = mode_hl,                  strings = { mode } },
                { hl = "MiniStatuslineDevinfo",  strings = { git, diff, diagnostics, lsp } },
                "%<",
                { hl = "MiniStatuslineFilename", strings = { filename } },
                "%=",
                { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
                { hl = mode_hl,                  strings = { search, location } },
            })
        end,
    },
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
require("mini.jump").setup()
require("mini.jump2d").setup()
require("mini.align").setup()
require("mini.bracketed").setup({
    undo = { suffix = "" },
})

local MiniMap = require("mini.map")
MiniMap.setup({
    integrations = {
        MiniMap.gen_integration.builtin_search(),
        MiniMap.gen_integration.diagnostic(),
        MiniMap.gen_integration.diff(),
    },
})
require("mini.comment").setup()
require("mini.move").setup()
require("mini.misc").setup()

require("treesj").setup({
    use_default_keymaps = false,
})

local mini_trailspace = require("mini.trailspace")
mini_trailspace.setup({ only_in_normal_buffers = true })

-- Unhighlight trailing whitespace when cursor moves for subtle editing
vim.api.nvim_create_autocmd("CursorMoved", {
    desc = "Unhighlight trailing whitespace on cursor movement",
    callback = function()
        mini_trailspace.unhighlight()
    end,
})

require("mini.cursorword").setup()
require("mini.indentscope").setup({
    symbol = "│",
    options = { try_as_border = true },
})

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
        zsh              = { "shfmt" },
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
        swift            = { "swiftformat", "swift_format", stop_after_first = true },
    },
})

-- Format buffer or visual selection (falls back to active LSP if no CLI tool)
vim.keymap.set({ "n", "v" }, "<leader>f", function()
    conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer or selection" })

-- ── 12. Git Integration ───────────────────────────────────────────────────
local MiniDiff = require("mini.diff")
MiniDiff.setup({
    view = {
        style = "sign",
        signs = { add = "▎", change = "▎", delete = "▎" },
    },
})

-- Format statusline diff summary cleanly (+add ~change -delete)
vim.api.nvim_create_autocmd("User", {
    pattern = "MiniDiffUpdated",
    callback = function(args)
        local summary = vim.b[args.buf].minidiff_summary
        if not summary then return end
        local t = {}
        if (summary.add or 0) > 0 then table.insert(t, "+" .. summary.add) end
        if (summary.change or 0) > 0 then table.insert(t, "~" .. summary.change) end
        if (summary.delete or 0) > 0 then table.insert(t, "-" .. summary.delete) end
        vim.b[args.buf].minidiff_summary_string = table.concat(t, " ")
    end,
})

local MiniGit = require("mini.git")
MiniGit.setup()

vim.keymap.set("n", "]h", function() MiniDiff.goto_hunk("next") end, { desc = "Next git hunk" })
vim.keymap.set("n", "[h", function() MiniDiff.goto_hunk("prev") end, { desc = "Previous git hunk" })
vim.keymap.set("n", "<leader>ghs", MiniDiff.operator, { desc = "Stage git hunk (operator)" })
vim.keymap.set("n", "<leader>ghp", function() MiniDiff.toggle_overlay() end, { desc = "Toggle git diff overlay" })
vim.keymap.set("n", "<leader>ghb", function() MiniGit.show_at_cursor() end, { desc = "Show git blame/commit at cursor" })

-- ── 13. Autocompletion & Snippets ─────────────────────────────────────────
local MiniCompletion = require("mini.completion")
MiniCompletion.setup({
    mappings = {
        force_twostep = "<C-Space>", -- Manually trigger completion popup
    },
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
local config_snippets = vim.fn.stdpath("config") .. "/snippets"

-- Dedicated loader for custom snippets in config directory
local function normalize_snippets(snips)
    local out = {}
    for _, s in ipairs(snips or {}) do
        local body = s.body
        if type(body) == "table" then
            body = table.concat(body, "\n")
        end
        if type(s.prefix) == "table" then
            for _, p in ipairs(s.prefix) do
                local copy = vim.deepcopy(s)
                copy.prefix = p
                copy.body = body
                table.insert(out, copy)
            end
        else
            local copy = vim.deepcopy(s)
            copy.body = body
            table.insert(out, copy)
        end
    end
    return out
end

local function custom_snippets_loader(context)
    local buf_id = (context or {}).buf_id or 0
    local ft = vim.bo[buf_id].filetype
    local lang = (context or {}).lang or ft
    local ft_aliases = {
        sh = { "sh", "bash" },
        bash = { "sh", "bash" },
        zsh = { "sh", "zsh" },
        terraform = { "terraform", "hcl" },
        ["terraform-vars"] = { "terraform", "hcl" },
    }
    local langs = ft_aliases[ft] or ft_aliases[lang] or { ft, lang }
    local res = {}
    local seen_files = {}
    for _, l in ipairs(langs) do
        local file = config_snippets .. "/" .. l .. ".json"
        if not seen_files[file] and vim.fn.filereadable(file) == 1 then
            seen_files[file] = true
            local snips = normalize_snippets(MiniSnippets.read_file(file))
            for _, s in ipairs(snips) do
                table.insert(res, s)
            end
        end
    end
    return res
end

local function global_snippets_loader()
    local file = config_snippets .. "/global.json"
    if vim.fn.filereadable(file) == 1 then
        return normalize_snippets(MiniSnippets.read_file(file))
    end
    return {}
end

MiniSnippets.setup({
    snippets = {
        -- 1. Community friendly-snippets
        MiniSnippets.gen_loader.from_lang(),
        -- 2. Custom local snippets from ~/.config/scvim/snippets/<filetype>.json
        custom_snippets_loader,
        -- 3. Universal shebangs and global snippets
        global_snippets_loader,
    },
    mappings = {
        expand = "<C-j>",
    },
    expand = {
        insert = function(snippet)
            MiniSnippets.default_insert(snippet, {
                empty_tabstop = "",
                empty_tabstop_final = "",
            })
        end,
    },
})
MiniSnippets.start_lsp_server({ match = false })

-- Snippet tabstop navigation & expansion
local function snippet_jump(direction)
    return function()
        if MiniSnippets.session.get() then
            MiniSnippets.session.jump(direction)
            return true
        end
    end
end

vim.keymap.set("i", "<C-j>", function()
    MiniSnippets.expand()
end, { desc = "Expand snippet under cursor" })
vim.keymap.set({ "i", "s" }, "<C-l>", snippet_jump("next"), { desc = "Jump to next snippet tabstop" })
vim.keymap.set({ "i", "s" }, "<C-h>", snippet_jump("prev"), { desc = "Jump to previous snippet tabstop" })

-- ── 14. Syntax & LSP Loaders ──────────────────────────────────────────────
require("treesitter")
require("lsp")

-- ── 15. Tabout ────────────────────────────────────────────────────────────
-- Move through closing brackets and quotes with Tab, while leaving completion
-- and snippet controls available for their existing mappings.
require("tabout").setup({
    tabkey = "<Tab>",
    backwards_tabkey = "<S-Tab>",
    act_as_tab = true,
    act_as_shift_tab = false,
    completion = true,
    ignore_beginning = true,
})


-- ── 16. zdiff ────────────────────────────────────────────────────────────
-- Git diff viewer inspired by Zed's multi-buffer diff viewer
require("zdiff").setup({
    -- Whether files are expanded by default
    default_expanded = false,

    -- Default branch for toggle_mode (m key)
    default_branch = "main",

    -- keymap bindings (defaults)
    keymaps = {
        goto_file = "<CR>",
        toggle = "<Tab>",
        close = "q",
        refresh = "R",
        toggle_mode = "m",
        help = "?",
        yank_ref = "gy",
    },

    -- icons for the UI elements
    icons = {
        collapsed = "",
        expanded = "",
        added = "+",
        deleted = "-",
        modified = "~",
    },

    -- syntax highlighting strategy
    syntax = {
        -- "projection" parses old/new full-file snapshots and projects
        -- captures onto unified diff lines. "hunk" keeps legacy behavior.
        mode = "projection",
        -- skip projection when either old/new sources exceed this many lines.
        -- 0 means unlimited
        max_lines = 8000,
    },
})

vim.keymap.set("n", "<leader>gz", "<cmd>Zdiff<cr>", { desc = "Diff Uncommitted changes (diff vs HEAD)" })
