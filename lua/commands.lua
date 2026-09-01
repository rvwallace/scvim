-- ── Package Management (vim.pack wrapper commands) ─────────────────────────

-- Add plugins to the current active session
vim.api.nvim_create_user_command("PackAdd", function(opts)
    vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins to active session (:PackAdd <url>)" })

-- Delete plugins from disk. Remove from pack.lua and restart before running this.
vim.api.nvim_create_user_command("PackDel", function(opts)
    vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins (:PackDel <plugin1> <plugin2>)" })

-- Clean up and remove inactive/orphaned plugins from disk
vim.api.nvim_create_user_command("PackClean", function()
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

    local choice = vim.fn.confirm("Remove unused plugins (" .. table.concat(unused_plugins, ", ") .. ")?", "&Yes\n&No", 2)
    if choice == 1 then
        vim.pack.del(unused_plugins)
        vim.notify("Removed unused plugins: " .. table.concat(unused_plugins, ", "), vim.log.levels.INFO)
    end
end, { desc = "Remove unused plugins from disk" })

-- Update all installed plugins or specific named plugins
vim.api.nvim_create_user_command("PackUpdate", function(opts)
    if opts.args:match("%S") then
        local plugins = vim.split(opts.args, "%s+", { trimempty = true })
        vim.pack.update(plugins)
    else
        vim.pack.update()
    end
end, { nargs = "*", desc = "Update all plugins or specific ones" })
