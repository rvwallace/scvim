-- Set space as leader key
vim.g.mapleader = " "

-- ── General Operations ────────────────────────────────────────────────────
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlighting", silent = true })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle line comment" })
vim.keymap.set("v", "<leader>/", "gc",  { remap = true, desc = "Toggle selection comment" })
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<cr>", { silent = true, desc = "Make file executable" })

-- ── Splits & Windows (<leader>s) ──────────────────────────────────────────
vim.keymap.set("n", "<leader>ss", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<left><Left><Left>]],
    { desc = "Substitute word under cursor globally" })
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>s=", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sz", function() require("mini.misc").zoom() end, { desc = "Toggle window zoom/maximize" })
vim.keymap.set("n", "<leader>sm", function() require("mini.misc").zoom() end, { desc = "Toggle window zoom/maximize" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close current split window" })

-- Direct split window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Focus lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Focus upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })

-- Split window resizing
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- ── Comment Line Insertion ────────────────────────────────────────────────
local function insert_comment(mode)
    local cs = vim.bo.commentstring
    if not cs or cs == "" then cs = "-- %s" end
    local left, right = cs:match("^(.-)%%s(.-)$")
    left = left or "-- "
    right = right or ""
    if left:match("%S$") then left = left .. " " end

    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local indent = line:match("^(%s*)") or ""

    if mode == "below" then
        local new_line = indent .. left .. right
        vim.api.nvim_buf_set_lines(0, row, row, false, { new_line })
        vim.api.nvim_win_set_cursor(0, { row + 1, #indent + #left })
    elseif mode == "above" then
        local new_line = indent .. left .. right
        vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { new_line })
        vim.api.nvim_win_set_cursor(0, { row, #indent + #left })
    elseif mode == "eol" then
        local spacer = (line:match("%S$") and " " or "")
        local new_line = line .. spacer .. left .. right
        vim.api.nvim_set_current_line(new_line)
        vim.api.nvim_win_set_cursor(0, { row, #new_line - #right })
    end
    vim.cmd("startinsert!")
end

vim.keymap.set("n", "gco", function() insert_comment("below") end, { desc = "Insert comment line below" })
vim.keymap.set("n", "gcO", function() insert_comment("above") end, { desc = "Insert comment line above" })
vim.keymap.set("n", "gcA", function() insert_comment("eol") end,   { desc = "Insert comment at end of line" })

-- ── Movement & Scrolling ──────────────────────────────────────────────────
-- Wrap-aware vertical movement (moves visually unless a count like 5j is provided)
vim.keymap.set("n", "j", function()
    return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
    return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

-- Centered scrolling: zz centers cursor after half-page jump
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page (centered)" })

-- Centered search navigation
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Join lines without moving cursor position (mz sets mark z, `z returns to it)
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- ── Visual Mode Line Movement & Indentation ───────────────────────────────
-- Move selected lines up/down and re-indent (gv reselects visual block)
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move visual selection down" })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move visual selection up" })

-- Indent/unindent while preserving visual selection
vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })

-- Repeat last normal mode edit across every line in visual selection
vim.keymap.set("x", ".", function()
    return "<esc><cmd>'<,'>normal! " .. vim.v.count1 .. ".<cr>"
end, { expr = true, desc = "Repeat last edit on visual selection" })

-- ── Clipboard & Delete ────────────────────────────────────────────────────
-- Delete single character without clobbering clipboard register
vim.keymap.set("n", "x", '"_x', { desc = "Delete character without copying" })

-- Paste over visual selection without losing yanked buffer to black hole register
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste over selection without losing clipboard" })

-- Delete into black hole register (doesn't overwrite yank buffer)
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without copying (black hole)" })

-- Copy file path information to system clipboard
vim.keymap.set("n", "<leader>yp", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path)
end, { desc = "Yank absolute file path" })

vim.keymap.set("n", "<leader>yr", function()
    local relpath = vim.fn.expand("%:~:.")
    vim.fn.setreg("+", relpath)
    vim.notify("Copied: " .. relpath)
end, { desc = "Yank relative file path" })

vim.keymap.set("n", "<leader>yn", function()
    local name = vim.fn.expand("%:t")
    vim.fn.setreg("+", name)
    vim.notify("Copied: " .. name)
end, { desc = "Yank file name" })

-- ── Insert Information (<leader>i) ───────────────────────────────────────
local function insert_text(text)
    vim.api.nvim_put({ text }, "c", true, true)
end

vim.keymap.set("n", "<leader>id", function()
    insert_text(os.date("%Y-%m-%d"))
end, { desc = "Insert date (YYYY-MM-DD)" })

vim.keymap.set("n", "<leader>it", function()
    insert_text(os.date("%H:%M:%S"))
end, { desc = "Insert time (HH:MM:SS)" })

vim.keymap.set("n", "<leader>is", function()
    insert_text(os.date("%Y-%m-%dT%H:%M:%S"))
end, { desc = "Insert ISO timestamp" })

vim.keymap.set("n", "<leader>if", function()
    insert_text(vim.fn.expand("%:t"))
end, { desc = "Insert current file name" })

vim.keymap.set("n", "<leader>ip", function()
    insert_text(vim.fn.expand("%:p"))
end, { desc = "Insert full file path" })

vim.keymap.set("n", "<leader>iu", function()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    local uuid = string.gsub(template, "[xy]", function(c)
        local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format("%x", v)
    end)
    insert_text(uuid)
end, { desc = "Insert random UUID v4" })

-- ── Buffer & Diagnostic Navigation ─────────────────────────────────────────
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>",     { desc = "Next buffer" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end,  { desc = "Next diagnostic" })

-- ── Code Actions & Editing (<leader>c) ────────────────────────────────────
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostic float" })
vim.keymap.set("n", "<leader>cw", function()
    local ok, trailspace = pcall(require, "mini.trailspace")
    if ok then
        trailspace.trim()
    else
        vim.cmd([[%s/\s\+$//e]])
    end
end, { desc = "Trim trailing whitespace" })

-- ── Undotree ──────────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>u", function()
    vim.cmd.packadd("nvim.undotree")
    require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })

-- ── Quick Toggles (<leader>t) ─────────────────────────────────────────────
vim.keymap.set("n", "<leader>tw", function()
    vim.wo.wrap = not vim.wo.wrap
    vim.notify("Wrap: " .. (vim.wo.wrap and "ON" or "OFF"))
end, { desc = "Toggle word wrap" })

vim.keymap.set("n", "<leader>tr", function()
    vim.wo.relativenumber = not vim.wo.relativenumber
    vim.notify("Relative number: " .. (vim.wo.relativenumber and "ON" or "OFF"))
end, { desc = "Toggle relative numbers" })

vim.keymap.set("n", "<leader>tn", function()
    vim.wo.number = not vim.wo.number
    vim.notify("Line numbers: " .. (vim.wo.number and "ON" or "OFF"))
end, { desc = "Toggle line numbers" })

vim.keymap.set("n", "<leader>td", function()
    local enabled = vim.diagnostic.is_enabled()
    vim.diagnostic.enable(not enabled)
    vim.notify("Diagnostics: " .. (not enabled and "ON" or "OFF"))
end, { desc = "Toggle LSP diagnostics" })

vim.keymap.set("n", "<leader>ts", function()
    vim.wo.spell = not vim.wo.spell
    vim.notify("Spell check: " .. (vim.wo.spell and "ON" or "OFF"))
end, { desc = "Toggle spell check" })

vim.keymap.set("n", "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle markdown render" })
vim.keymap.set("n", "<leader>tc", "<cmd>CsvViewToggle<cr>",          { desc = "Toggle CSV table view" })
vim.keymap.set("n", "<leader>tg", function()
    local ok, diff = pcall(require, "mini.diff")
    if ok then
        diff.toggle()
        vim.notify("Toggled git diff gutter signs")
    end
end, { desc = "Toggle Git diff signs" })

-- ── Floating & Split Terminals ────────────────────────────────────────────
local float_term = { buf = nil, win = nil }

local function toggle_floating_terminal()
    if float_term.win and vim.api.nvim_win_is_valid(float_term.win) then
        vim.api.nvim_win_close(float_term.win, false)
        float_term.win = nil
        return
    end

    if not float_term.buf or not vim.api.nvim_buf_is_valid(float_term.buf) then
        float_term.buf = vim.api.nvim_create_buf(false, true)
        vim.bo[float_term.buf].bufhidden = "hide"
    end

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    float_term.win = vim.api.nvim_open_win(float_term.buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    if vim.bo[float_term.buf].buftype ~= "terminal" then
        vim.fn.jobstart(os.getenv("SHELL") or "zsh", { term = true })
    end

    vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>tf", toggle_floating_terminal, { desc = "Toggle floating terminal" })
vim.keymap.set("n", "<leader>tt", function()
    vim.cmd("botright 12split | terminal")
end, { desc = "Open bottom terminal split" })
vim.keymap.set("n", "<leader>tv", function()
    vim.cmd("vsplit | terminal")
end, { desc = "Open vertical terminal split" })

-- ── Quit & Session (<leader>q) ────────────────────────────────────────────
vim.keymap.set("n", "<leader>qq", "<cmd>confirm qa<cr>", { desc = "Quit all (prompt to save)" })
vim.keymap.set("n", "<leader>qw", "<cmd>xa<cr>",         { desc = "Save all and quit" })
vim.keymap.set("n", "<leader>qf", "<cmd>qa!<cr>",        { desc = "Force quit all" })
vim.keymap.set("n", "<leader>qr", "<cmd>restart<cr>",    { desc = "Restart Neovim (:restart)" })

-- ── Vim & System (<leader>v) ──────────────────────────────────────────────
vim.keymap.set("n", "<leader>vm", "<cmd>Mason<cr>",       { desc = "Mason package manager" })
vim.keymap.set("n", "<leader>vk", "<cmd>checkhealth<cr>", { desc = "Check health (:checkhealth)" })
vim.keymap.set("n", "<leader>vl", "<cmd>messages<cr>",    { desc = "View messages and error log" })
vim.keymap.set("n", "<leader>vr", "<cmd>restart<cr>",     { desc = "Restart Neovim (:restart)" })

-- ── Help & Documentation (<leader>h) ──────────────────────────────────────
local function open_doc(filename)
    local config_dir = vim.fn.stdpath("config")
    local path = vim.fs.joinpath(config_dir, filename)
    if vim.fn.filereadable(path) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(path))
    else
        vim.notify("Documentation file not found: " .. path, vim.log.levels.WARN)
    end
end

vim.keymap.set("n", "<leader>hc", function() open_doc("CHEATSHEET.md") end, { desc = "Open Cheatsheet" })
vim.keymap.set("n", "<leader>hr", function() open_doc("README.md") end,     { desc = "Open Readme" })
vim.keymap.set("n", "<leader>hl", function() open_doc("CHANGELOG.md") end,  { desc = "Open Changelog" })
vim.keymap.set("n", "<leader>hk", function() open_doc("LANGUAGES.md") end,  { desc = "Open Languages matrix" })
vim.keymap.set("n", "<leader>hh", "<cmd>lua require('mini.pick').builtin.help()<cr>", { desc = "Search Neovim help tags" })
