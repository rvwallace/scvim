-- ── Package Management (vim.pack wrapper commands) ─────────────────────────

-- Add plugins to the current active session
vim.api.nvim_create_user_command("SCPackAdd", function(opts)
    vim.pack.add(opts.fargs, { confirm = not opts.bang })
end, { nargs = "+", bang = true, desc = "Add plugins to active session (:SCPackAdd <url>)" })

-- Delete plugins from disk. Remove from pack.lua and restart before running this.
vim.api.nvim_create_user_command("SCPackDel", function(opts)
    vim.pack.del(opts.fargs, { force = opts.bang })
end, { nargs = "+", bang = true, desc = "Delete plugins (:SCPackDel <plugin1> <plugin2>)" })

-- Clean up and remove inactive/orphaned plugins from disk
vim.api.nvim_create_user_command("SCPackClean", function(opts)
    local active_plugins = {}
    local unused_plugins = {}

    for _, plugin in ipairs(vim.pack.get()) do
        active_plugins[plugin.spec.name] = plugin.active
    end

    for _, plugin in ipairs(vim.pack.get()) do
        if not active_plugins[plugin.spec.name] then
            table.insert(unused_plugins, plugin.spec.name)
        end
    end

    if #unused_plugins == 0 then
        vim.notify("No unused plugins found.", vim.log.levels.INFO)
        return
    end

    local choice = opts.bang and 1 or vim.fn.confirm("Remove unused plugins (" .. table.concat(unused_plugins, ", ") .. ")?", "&Yes\n&No", 2)
    if choice == 1 then
        vim.pack.del(unused_plugins, { force = opts.bang })
        vim.notify("Removed unused plugins: " .. table.concat(unused_plugins, ", "), vim.log.levels.INFO)
    end
end, { bang = true, desc = "Remove unused plugins from disk" })

-- Update all installed plugins or specific named plugins
vim.api.nvim_create_user_command("SCPackUpdate", function(opts)
    if opts.args:match("%S") then
        local plugins = vim.split(opts.args, "%s+", { trimempty = true })
        vim.pack.update(plugins, { force = opts.bang })
    else
        vim.pack.update(nil, { force = opts.bang })
    end
end, { nargs = "*", bang = true, desc = "Update all plugins or specific ones" })

-- Install all configured Mason-managed LSP servers and formatters.
local function install_mason_packages(on_complete)
    local registry = require("mason-registry")
    local packages = require("languages").mason_packages()
    local missing = {}
    local failures = {}

    registry.refresh(function(success, err)
        if success == false then
            vim.notify("Mason registry refresh failed: " .. tostring(err), vim.log.levels.ERROR)
            return
        end

        for _, name in ipairs(packages) do
            if registry.has_package(name) then
                local package = registry.get_package(name)
                if not package:is_installed() then
                    table.insert(missing, package)
                end
            else
                table.insert(failures, name .. " (not in Mason registry)")
            end
        end

        if #missing == 0 then
            if #failures > 0 then
                vim.notify("Mason skipped: " .. table.concat(failures, ", "), vim.log.levels.WARN)
            else
                vim.notify("All configured Mason packages are already installed.", vim.log.levels.INFO)
            end
            if on_complete then on_complete() end
            return
        end

        local remaining = #missing
        for _, package in ipairs(missing) do
            package:install({}, function(success, result)
                if not success then
                    table.insert(failures, package.name .. ": " .. tostring(result))
                end
                remaining = remaining - 1
                if remaining == 0 then
                    if #failures > 0 then
                        vim.notify("Mason installation finished with errors: " .. table.concat(failures, "; "), vim.log.levels.ERROR)
                    else
                        vim.notify("Installed " .. #missing .. " Mason package(s).", vim.log.levels.INFO)
                    end
                    if on_complete then on_complete() end
                end
            end)
        end
    end)
end

vim.api.nvim_create_user_command("SCMasonInstallAll", function()
    install_mason_packages()
end, { desc = "Install configured Mason LSP servers and formatters" })

vim.api.nvim_create_user_command("SCTreesitterInstallAll", function()
    require("nvim-treesitter").install(require("languages").treesitter_parsers())
    vim.notify("Requested configured Tree-sitter parsers.", vim.log.levels.INFO)
end, { desc = "Install configured Tree-sitter parsers" })

vim.api.nvim_create_user_command("SCInstallAll", function()
    require("nvim-treesitter").install(require("languages").treesitter_parsers())
    install_mason_packages()
    vim.notify("Requested configured Mason packages and Tree-sitter parsers.", vim.log.levels.INFO)
end, { desc = "Install all configured language support" })

-- Open the current file in the macOS Obsidian application.
vim.api.nvim_create_user_command("ObsidianOpen", function()
    if vim.fn.has("mac") ~= 1 then
        vim.notify("ObsidianOpen is currently supported only on macOS.", vim.log.levels.WARN)
        return
    end

    local path = vim.fn.expand("%:p")
    if path == "" then
        vim.notify("No file is open in the current buffer.", vim.log.levels.WARN)
        return
    end

    local result = vim.system({ "open", "-a", "Obsidian", "--", path }):wait()
    if result.code ~= 0 then
        vim.notify("Could not open file in Obsidian:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
    end
end, { desc = "Open current file in Obsidian" })
