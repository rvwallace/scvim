-- ── 1. Mason Package Manager ──────────────────────────────────────────────
require("mason").setup()

-- ── 2. LSP Keymaps & Diagnostic Settings ──────────────────────────────────
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 4 },
    underline = true,        -- Underline problematic code
    update_in_insert = false, -- Avoid recalculating while typing
    severity_sort = true,
    float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
})

-- Rounded borders for all LSP floating previews (hover, signature help, etc.)
do
    local orig = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        return orig(contents, syntax, opts, ...)
    end
end

-- ── 3. Client Capabilities (mini.completion integration) ──────────────────
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())
vim.lsp.config("*", { capabilities = capabilities })

-- ── 4. Server-Specific Configurations ─────────────────────────────────────
-- Lua Language Server: recognize the global `vim` object
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        },
    },
})

-- Python (Ruff + Basedpyright): disable Ruff's hover provider so
-- Basedpyright handles documentation hover while Ruff handles linting/formatting
vim.lsp.config("ruff", {
    on_attach = function(client)
        client.server_capabilities.hoverProvider = false
    end,
})

-- YAML (SchemaStore): automatic validation for GitHub Actions, K8s, Compose, etc.
vim.lsp.config("yamlls", {
    settings = {
        yaml = {
            schemaStore = {
                enable = false, -- use SchemaStore.nvim catalog instead of bundled store
                url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
            validate = true,
            hover = true,
            completion = true,
        },
    },
})

-- Terraform LS: root_dir prefers .terraform, then .git, for child modules without their own state.
-- Enhanced validation off; it can false-positive on Helm 2.x set blocks and similar patterns.
vim.lsp.config("terraformls", {
    cmd = { vim.fn.stdpath("data") .. "/mason/bin/terraform-ls", "serve" },
    filetypes = { "terraform", "terraform-vars" },
    root_dir = function(fname)
        local tf = vim.fs.find(".terraform", { path = fname, upward = true })[1]
        if tf then
            return vim.fs.dirname(tf)
        end
        local git = vim.fs.find(".git", { path = fname, upward = true })[1]
        if git then
            return vim.fs.dirname(git)
        end
        return vim.fs.dirname(fname)
    end,
    init_options = {
        validation = {
            enableEnhancedValidation = false,
        },
    },
})

-- ── 5. Server Activation ──────────────────────────────────────────────────
-- Install on new machine with:
-- :MasonInstall ansible-language-server bash-language-server basedpyright css-lsp dockerfile-language-server gopls html-lsp json-lsp marksman ruff rust-analyzer taplo terraform-ls typescript-language-server yaml-language-server
local servers = {
    "ansiblels",
    "bashls",
    "basedpyright",
    "cssls",
    "dockerls",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "marksman",
    "ruff",
    "rust_analyzer",
    "taplo",
    "ts_ls",
    "yamlls",
}

vim.lsp.enable(servers)
vim.lsp.enable("terraformls")
