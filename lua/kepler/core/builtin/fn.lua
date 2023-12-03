local M = {}

--- Get the path for a directory relevant to Kepler. Not specifying a name will return
--- the root directory for those obtainable by specifying it.
---@param what? "data"|"cache"|"state"|"lib"|"lazy"|"all"
---@return string|string[] path
function M.stdpath(what)
    local dirname = kepler.debug.resolution_root_dir.nvimconf:get(vim.fn.stdpath "config")
        .. "/.kepler"
    if not what then return dirname end

    local options = { "data", "cache", "state", "lib", "lazy", "all" }
    if type(what) ~= "string" or not vim.iter(options):any(function(x) return x == what end) then
        error("'mode' must be nil or one the following strings: " .. tostring(options))
    end

    if what == "all" then
        return options:map(function(x)
            if x == "all" then return nil end
            return dirname .. "/" .. x
        end)
    end

    if what == "lazy" then kepler.debug.resolution_root_dir.lazynvim:get(dirname .. "/" .. what) end

    return dirname .. "/" .. what
end

return M
