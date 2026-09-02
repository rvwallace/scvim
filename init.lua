-- Experimental Neovim UI2 internal feature (safely guarded)
pcall(function()
    require("vim._core.ui2").enable({})
end)

-- ── Core Modules ──────────────────────────────────────────────────────────
require("options")   -- Editor settings and buffer options
require("keymaps")   -- Key mappings and leader bindings
require("commands")  -- Custom user commands (vim.pack wrappers)
require("autocmds")  -- Event handlers and filetype rules
require("pack")      -- Plugins, mini.nvim modules, Treesitter, and LSP

-- ── Color Scheme ──────────────────────────────────────────────────────────
vim.cmd.colorscheme("catppuccin")
