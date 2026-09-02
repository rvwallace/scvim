-- Disable netrw directory banner
vim.g.netrw_banner = 0

-- ── Line Numbers & Gutter ──────────────────────────────────────────────────
vim.opt.nu = true              -- Show line numbers
vim.opt.relativenumber = true  -- Relative line numbers for easier jump distance calculation
vim.opt.signcolumn = "yes:2"   -- 2-column sign gutter (displays Git signs and LSP diagnostics side-by-side)
vim.opt.colorcolumn = "0"      -- Column guide (disabled by default)

-- ── Indentation & Tabs ────────────────────────────────────────────────────
vim.opt.tabstop = 4            -- 1 tab = 4 spaces
vim.opt.softtabstop = 4        -- Number of spaces inserted on <Tab>
vim.opt.shiftwidth = 4         -- Indentation width
vim.opt.expandtab = true       -- Convert tabs to spaces
vim.opt.smartindent = true     -- Autoindent new lines smartly

-- ── Splits & Windows ──────────────────────────────────────────────────────
vim.opt.splitbelow = true      -- Horizontal splits open below current window
vim.opt.splitright = true      -- Vertical splits open to the right
vim.opt.laststatus = 3         -- Global statusline across all splits

-- ── Search & Substitution ─────────────────────────────────────────────────
vim.opt.ignorecase = true      -- Case-insensitive search by default
vim.opt.smartcase = true       -- Case-sensitive if query contains capital letters
vim.opt.inccommand = "split"   -- Show live substitution preview in a split window
vim.opt.diffopt:append("linematch:60") -- Smarter diff display aligning modified lines

-- ── Backup, Swap & Persistent Undo ────────────────────────────────────────
vim.opt.swapfile = false       -- Disable swapfiles
vim.opt.backup = false         -- Disable backup files
vim.opt.undofile = true        -- Save persistent undo history to disk
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"

-- ── Completion & Messages ─────────────────────────────────────────────────
vim.opt.completeopt = "menuone,noselect,fuzzy,nosort" -- Modern fuzzy completion behavior
vim.opt.shortmess:append("c")                         -- Don't show extra completion messages

-- ── Editor Behavior & Quality of Life ─────────────────────────────────────
vim.opt.clipboard:append("unnamedplus") -- Sync with system clipboard
vim.opt.confirm = true                  -- Prompt to save changes on :q instead of failing
vim.opt.scrolloff = 8                   -- Keep 8 lines of vertical context above/below cursor
vim.opt.sidescrolloff = 8               -- Keep 8 columns of horizontal context
vim.opt.wrap = true                     -- Wrap long lines visually
vim.opt.termguicolors = true            -- Enable 24-bit RGB true colors
vim.opt.guicursor = ""                  -- Keep terminal default cursor shape
vim.opt.isfname:append("@-@")           -- Include '@' in filename path matching
