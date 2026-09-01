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

-- Go standard formatting: hard tabs (expandtab = false)
autocmd("FileType", {
    desc = "Set hard tabs for Go files",
    pattern = { "go" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = false
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
