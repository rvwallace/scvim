-- Single source of truth for language support and fresh-machine installation.
local M = {}

M.languages = {
    { name = "ansible", parsers = { "yaml" }, lsp = "ansiblels", mason = "ansible-language-server" },
    { name = "bash", parsers = { "bash" }, lsp = "bashls", mason = "bash-language-server" },
    { name = "css", parsers = { "css" }, lsp = "cssls", mason = "css-lsp" },
    { name = "docker", parsers = { "dockerfile" }, lsp = "dockerls", mason = "dockerfile-language-server" },
    { name = "go", parsers = { "go", "gomod", "gosum", "gowork" }, lsp = "gopls", mason = "gopls" },
    { name = "html", parsers = { "html" }, lsp = "html", mason = "html-lsp" },
    { name = "json", parsers = { "json", "json5" }, lsp = "jsonls", mason = "json-lsp" },
    { name = "lua", parsers = { "lua", "vim", "vimdoc", "query" }, lsp = "lua_ls", mason = "lua-language-server" },
    { name = "markdown", parsers = { "markdown", "markdown_inline" }, lsp = "marksman", mason = "marksman" },
    { name = "python", parsers = { "python" }, lsp = { "basedpyright", "ruff" }, mason = { "basedpyright", "ruff" } },
    { name = "rust", parsers = { "rust" }, lsp = "rust_analyzer", mason = "rust-analyzer" },
    { name = "swift", parsers = { "swift" }, lsp = "sourcekit", system = "sourcekit-lsp" },
    { name = "terraform", parsers = { "terraform" }, lsp = "terraformls", mason = "terraform-ls" },
    { name = "toml", parsers = { "toml" }, lsp = "taplo", mason = "taplo" },
    { name = "typescript", parsers = { "javascript", "typescript", "tsx" }, lsp = "ts_ls", mason = "typescript-language-server" },
    { name = "yaml", parsers = { "yaml" }, lsp = "yamlls", mason = "yaml-language-server" },
}

M.utility_parsers = { "http" }

M.formatter_packages = {
    "stylua",
    "ruff",
    "goimports",
    "shfmt",
    "prettier",
    "swiftformat",
}

local function append_unique(out, seen, value)
    if value and not seen[value] then
        seen[value] = true
        table.insert(out, value)
    end
end

local function append_values(out, seen, values)
    if type(values) == "string" then
        append_unique(out, seen, values)
    else
        for _, value in ipairs(values or {}) do
            append_unique(out, seen, value)
        end
    end
end

function M.treesitter_parsers()
    local parsers, seen = {}, {}
    for _, language in ipairs(M.languages) do
        append_values(parsers, seen, language.parsers)
    end
    append_values(parsers, seen, M.utility_parsers)
    return parsers
end

function M.lsp_servers()
    local servers, seen = {}, {}
    for _, language in ipairs(M.languages) do
        append_values(servers, seen, language.lsp)
    end
    return servers
end

function M.mason_packages()
    local packages, seen = {}, {}
    for _, language in ipairs(M.languages) do
        append_values(packages, seen, language.mason)
    end
    append_values(packages, seen, M.formatter_packages)
    return packages
end

return M
