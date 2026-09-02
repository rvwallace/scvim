local autocmd = vim.api.nvim_create_autocmd

-- ── Visual Feedback ───────────────────────────────────────────────────────
-- Highlight briefly when yanking text
autocmd("TextYankPost", {
    desc = "Highlight yanked text briefly",
    callback = function()
        vim.hl.on_yank()
    end,
})

-- ── File Synchronization ──────────────────────────────────────────────────
-- Auto-reload buffers when modified on disk outside Neovim (e.g. git checkout)
autocmd({ "FocusGained", "BufEnter" }, {
    desc = "Auto-reload files modified outside Neovim",
    callback = function()
        if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
})

-- Return to last cursor position when reopening a file
autocmd("BufReadPost", {
    desc = "Restore last cursor position",
    callback = function(args)
        if vim.o.diff then
            return
        end
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- ── Formatting & Editing Behavior ─────────────────────────────────────────
-- Prevent automatic insertion of comment leaders on new lines (Enter or o/O)
autocmd("FileType", {
    desc = "Disable automatic comment continuation on new line",
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- ── Language-Specific Indentation ─────────────────────────────────────────
-- YAML, Ansible, Terraform, and HCL standard 2-space indentation
autocmd("FileType", {
    desc = "Set 2-space indentation for YAML, Terraform, and HCL",
    pattern = { "yaml", "yaml.ansible", "terraform", "hcl" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
    end,
})

-- ── Language Execution Helper ─────────────────────────────────────────────
local function run_in_term(cmd)
    vim.cmd("silent! write")
    vim.cmd("botright 12split | terminal " .. cmd)
end

-- ── Python Language Actions (<leader>l in Python, uv-native) ───────────────
autocmd("FileType", {
    desc = "Setup Python buffer settings and dynamic <leader>l actions (uv-native)",
    pattern = { "python" },
    callback = function(args)
        local buf = args.buf
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end

        -- Run current script via uv
        map("n", "<leader>lr", function()
            local file = vim.fn.expand("%")
            run_in_term("uv run " .. vim.fn.fnameescape(file))
        end, "Run script (uv run %)")

        -- Run pytest across workspace
        map("n", "<leader>lt", function()
            run_in_term("uv run pytest")
        end, "Run all tests (uv run pytest)")

        -- Run pytest on current file
        map("n", "<leader>lT", function()
            local file = vim.fn.expand("%")
            run_in_term("uv run pytest " .. vim.fn.fnameescape(file))
        end, "Run tests in file (uv run pytest %)")

        -- Launch interactive Python REPL with uv environment
        map("n", "<leader>li", function()
            run_in_term("uv run python")
        end, "Open Python REPL (uv run python)")

        -- Insert PEP 723 inline script metadata block header
        map("n", "<leader>lm", function()
            local pep723 = {
                "# /// script",
                '# requires-python = ">=3.11"',
                "# dependencies = [",
                "# ]",
                "# ///",
                "",
            }
            local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
            local start_idx = first_line:match("^#!") and 1 or 0
            vim.api.nvim_buf_set_lines(buf, start_idx, start_idx, false, pep723)
            vim.notify("Inserted PEP 723 inline script metadata header")
        end, "Insert PEP 723 script metadata header")

        -- Sync script dependencies and refresh LSP
        map("n", "<leader>ls", function()
            local file = vim.fn.expand("%")
            vim.cmd("silent! write")
            vim.notify("Syncing script dependencies with uv...", vim.log.levels.INFO)
            local out = vim.fn.system({ "uv", "sync", "--script", file })
            if vim.v.shell_error == 0 then
                vim.notify("uv sync complete! Reloading LSP...", vim.log.levels.INFO)
                vim.cmd("lsp restart")
            else
                vim.notify("uv sync failed:\n" .. out, vim.log.levels.ERROR)
            end
        end, "Sync script dependencies (uv sync --script %)")
    end,
})

-- ── Go Language Actions (<leader>l in Go) ──────────────────────────────────
autocmd("FileType", {
    desc = "Setup Go buffer settings and dynamic <leader>l actions",
    pattern = { "go" },
    callback = function(args)
        local buf = args.buf
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = false

        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end

        -- Run package / main
        map("n", "<leader>lr", function()
            run_in_term("go run .")
        end, "Run Go package (go run .)")

        -- Run all tests
        map("n", "<leader>lt", function()
            run_in_term("go test ./...")
        end, "Run all tests (go test ./...)")

        -- Run tests for current package
        map("n", "<leader>lT", function()
            run_in_term("go test -v .")
        end, "Run package tests (go test -v .)")

        -- Go mod tidy
        map("n", "<leader>lm", function()
            run_in_term("go mod tidy")
        end, "Go mod tidy")

        -- Go generate
        map("n", "<leader>lg", function()
            run_in_term("go generate ./...")
        end, "Go generate (go generate ./...)")

        -- Go vet
        map("n", "<leader>lv", function()
            run_in_term("go vet ./...")
        end, "Go vet (go vet ./...)")
    end,
})

-- ── Swift Language Actions (<leader>l in Swift) ────────────────────────────
autocmd("FileType", {
    desc = "Setup Swift buffer settings and dynamic <leader>l actions",
    pattern = { "swift" },
    callback = function(args)
        local buf = args.buf
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true

        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end

        -- Run package via swift run
        map("n", "<leader>lr", function()
            run_in_term("swift run")
        end, "Run Swift package (swift run)")

        -- Build package via swift build
        map("n", "<leader>lb", function()
            run_in_term("swift build")
        end, "Build package (swift build)")

        -- Run tests via swift test
        map("n", "<leader>lt", function()
            run_in_term("swift test")
        end, "Run tests (swift test)")

        -- Resolve package dependencies
        map("n", "<leader>lp", function()
            run_in_term("swift package resolve")
        end, "Resolve package dependencies (swift package resolve)")
    end,
})

-- ── Markdown Language Actions (<leader>l in Markdown) ──────────────────────
local function toggle_markdown_task(line)
    if line:match("^%s*[%-%*%+]%s+%[%s%]") then
        return (line:gsub("^(%s*[%-%*%+]%s+)%[%s%]", "%1[x]", 1))
    elseif line:match("^%s*[%-%*%+]%s+%[[xX]%]") then
        return (line:gsub("^(%s*[%-%*%+]%s+)%[[xX]%]", "%1[ ]", 1))
    elseif line:match("^%s*[%-%*%+]%s+") then
        return (line:gsub("^(%s*[%-%*%+]%s+)", "%1[ ] ", 1))
    elseif line:match("%S") then
        local indent, text = line:match("^(%s*)(.*)$")
        return indent .. "- [ ] " .. text
    end
    return line
end

local function toggle_markdown_bullet(line)
    if line:match("^%s*[%-%*%+]%s+") then
        return (line:gsub("^(%s*)[%-%*%+]%s+", "%1", 1))
    elseif line:match("%S") then
        local indent, text = line:match("^(%s*)(.*)$")
        return indent .. "- " .. text
    end
    return line
end

local function toggle_markdown_heading(level)
    local line = vim.api.nvim_get_current_line()
    local indent, content = line:match("^(%s*)#*%s*(.*)$")
    indent = indent or ""
    content = content or line

    local current_hashes = line:match("^%s*(#+)")
    if current_hashes and #current_hashes == level then
        vim.api.nvim_set_current_line(indent .. content)
    else
        vim.api.nvim_set_current_line(indent .. string.rep("#", level) .. " " .. content)
    end
end

autocmd("FileType", {
    desc = "Setup Markdown buffer settings and dynamic <leader>l actions",
    pattern = { "markdown" },
    callback = function(args)
        local buf = args.buf
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true

        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end

        -- Task toggle (normal and visual)
        map("n", "<leader>lx", function()
            local line = vim.api.nvim_get_current_line()
            vim.api.nvim_set_current_line(toggle_markdown_task(line))
        end, "Toggle task checkbox")

        map("v", "<leader>lx", function()
            local start_row = vim.fn.line("'<")
            local end_row = vim.fn.line("'>")
            local lines = vim.api.nvim_buf_get_lines(buf, start_row - 1, end_row, false)
            for i, l in ipairs(lines) do
                lines[i] = toggle_markdown_task(l)
            end
            vim.api.nvim_buf_set_lines(buf, start_row - 1, end_row, false, lines)
        end, "Toggle task checkboxes on selection")

        -- Preview toggle
        map("n", "<leader>lp", "<cmd>RenderMarkdown toggle<cr>", "Toggle markdown render preview")

        -- Bullets
        map("n", "<leader>lb", function()
            local line = vim.api.nvim_get_current_line()
            vim.api.nvim_set_current_line(toggle_markdown_bullet(line))
        end, "Toggle bullet list item")

        -- Headings 1 through 6
        map("n", "<leader>l1", function() toggle_markdown_heading(1) end, "Toggle Heading 1 (#)")
        map("n", "<leader>l2", function() toggle_markdown_heading(2) end, "Toggle Heading 2 (##)")
        map("n", "<leader>l3", function() toggle_markdown_heading(3) end, "Toggle Heading 3 (###)")
        map("n", "<leader>l4", function() toggle_markdown_heading(4) end, "Toggle Heading 4 (####)")
        map("n", "<leader>l5", function() toggle_markdown_heading(5) end, "Toggle Heading 5 (#####)")
        map("n", "<leader>l6", function() toggle_markdown_heading(6) end, "Toggle Heading 6 (######)")
    end,
})

-- ── Terminal Buffers ──────────────────────────────────────────────────────
-- Disable line numbers and sign column in terminal buffers, and enter insert mode
autocmd("TermOpen", {
    desc = "Configure clean terminal buffer settings and focus insert mode",
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.cmd("startinsert")
    end,
})

-- Auto-close terminal buffers on clean exit (exit code 0)
autocmd("TermClose", {
    desc = "Auto-close terminal buffer on successful process exit",
    callback = function(args)
        if vim.v.event.status == 0 then
            vim.api.nvim_buf_delete(args.buf, { force = false })
        end
    end,
})
