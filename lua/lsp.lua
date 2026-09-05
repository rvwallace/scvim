-- ── 1. Mason Package Manager ──────────────────────────────────────────────
require("mason").setup()

-- ── 2. LSP Keymaps & Diagnostic Settings ──────────────────────────────────
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", function()
    local ok, extra = pcall(require, "mini.extra")
    if ok then
        extra.pickers.lsp({ scope = "references" })
    else
        vim.lsp.buf.references()
    end
end, { desc = "Search references" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>co", function()
    vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" }, diagnostics = {} },
        apply = true,
    })
end, { desc = "Organize imports" })

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
        },
    },
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
    -- Suppress duplicate warning when intentionally wrapping Neovim core function
    ---@diagnostic disable-next-line: duplicate-set-field
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
-- Lua Language Server: recognize global `vim` object and Neovim runtime APIs
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME .. "/lua" },
            },
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

-- Resolve python interpreter dynamically for PEP 723 / uv scripts or local .venv
local function resolve_python_path(root_dir, bufname)
    -- 1. Check for PEP 723 inline script metadata / uv shebang in active buffer
    if bufname and bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
        local first_lines = vim.api.nvim_buf_get_lines(0, 0, 25, false)
        local is_script = false
        for _, line in ipairs(first_lines) do
            if line:match("^# /// script") or line:match("uv run %-%-script") then
                is_script = true
                break
            end
        end

        if is_script then
            -- Sync script dependencies if needed and retrieve environment interpreter
            vim.fn.system({ "uv", "sync", "--script", bufname })
            local script_py = vim.fn.systemlist({ "uv", "python", "find", "--script", bufname })[1]
            if vim.v.shell_error == 0 and script_py and script_py ~= "" and vim.fn.filereadable(script_py) == 1 then
                return script_py
            end
        end
    end

    -- 2. Check for local or parent .venv directory
    local venv = vim.fs.find(".venv", { path = root_dir or vim.fn.getcwd(), upward = true })[1]
    if venv and vim.fn.isdirectory(venv) == 1 then
        local venv_py = venv .. "/bin/python"
        if vim.fn.filereadable(venv_py) == 1 then
            return venv_py
        end
    end

    -- 3. Check VIRTUAL_ENV environment variable
    if vim.env.VIRTUAL_ENV then
        local env_py = vim.env.VIRTUAL_ENV .. "/bin/python"
        if vim.fn.filereadable(env_py) == 1 then
            return env_py
        end
    end

    return nil
end

vim.lsp.config("basedpyright", {
    before_init = function(params, config)
        local bufname = vim.api.nvim_buf_get_name(0)
        local root_dir = params.rootPath or params.rootUri
        local py_path = resolve_python_path(root_dir, bufname)
        if py_path then
            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            config.settings.python.pythonPath = py_path
        end
    end,
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "standard",
            },
        },
    },
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
-- Install configured tools on a new machine with :SCInstallAll.
local servers = require("languages").lsp_servers()

vim.lsp.enable(servers)
