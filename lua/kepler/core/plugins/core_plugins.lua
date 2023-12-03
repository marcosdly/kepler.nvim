--- Custom searcher and loader that allows you to have multiple of the
--- same plugins while still fully managed by lazy.nvim.
---
--- It checks for Kepler's internal lib name pattern, then tries to
--- manually load the respective lua chunks. If they can't be found,
--- throw a regular module-not-found type of error.
---
--- See `:help luaref-require()`
--- @see http://lua-users.org/wiki/LuaModulesLoader
--- @param modname string Module path given to `require()`
--- @return any # Arbitrary value returned by the respective lua chunk.
local function custom_searcher(modname)
    if modname:sub(1, 11) ~= "kepler.lib." then return end

    if modname:sub(#modname - 3) == ".lua" then
        return (
            "For Kepler's cobe libs, a package directory should not end with '.lua'. "
            .. "Check for a typo or modify the plugin's spec."
        )
    end

    local words = vim.iter(modname:sub(12):gmatch "%w+"):totable()
    table.insert(words, 2, "lua")
    words[1] = "kepler.lib." .. words[1]
    local path = kepler.fn.stdpath "lazy" .. "/" .. table.concat(words, "/")
    local init_path, module_path =
        path .. "/init.lua", string.format("%s/%s.lua", path, modname:match "%w+$")

    if #words == 2 then
        -- if path == (plugin dir)/lua then prioritize this method
        local chunk, err = loadfile(init_path)
        if not err then return chunk end
    end

    local chunk, err = loadfile(module_path)
    if not err then return chunk end
    chunk, err = loadfile(init_path)
    if not err then return chunk end
    return string.format(
        "Package/module '%s' does not exist. (checked with custom loader)\n"
            .. "Checked paths:\n\t%s\n\t%s",
        modname,
        module_path,
        init_path
    )
end

--table.insert(package.loaders, 1, custom_searcher)

return vim.iter({
    -- Development Dependencies
    {
        "nvim-lua/plenary.nvim",
        lazy = false,
        tag = "v0.1.4",
        name = "plenary",
    },
    {
        "lunarmodules/Penlight",
        lazy = false,
        tag = "1.13.1",
        name = "pl",
    },
})
    :map(function(x)
        x.dev, x.pin, x.name = false, true, "kepler.lib." .. x.name
        return x
    end)
    :totable()
