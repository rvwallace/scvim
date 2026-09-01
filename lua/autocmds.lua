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
