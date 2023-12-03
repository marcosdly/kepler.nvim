-- See lazy.nvim plugin spec at https://github.com/folke/lazy.nvim#-plugin-spec

---@class KeplerUserPlugin: LazyPluginSpec
---@field config boolean?
---@field init boolean?
---@field opts boolean?
---@field keys boolean?
---@field build boolean?

--- Takes a simplified version of LazyPluginSpec and tuns them into a regular LazyPluginSpec.
--- Auto assingns some attributes of the spec to return values of their respective configuration
--- lua modules. Besides that, abstract some procedures like the expansion of `<leader>` in a
--- LazyKeysSpec.
---@param plugins KeplerUserPlugin[] List of plugins with simplified notation to become regular specs.
---@return LazyPluginSpec[]
return function(plugins)
    return vim.iter(plugins)
        :map(function(spec)
            ---@cast spec KeplerUserPlugin
            if
                spec.enabled == nil
                or (type(spec.enabled) == "boolean" and spec.enabled)
                ---@diagnostic disable-next-line: param-type-mismatch
                or vim.iter({ pcall(spec.enabled) })
                    :all(function(v) return type(v) == "boolean" and v end)
            then -- luacheck: ignore 542
            else
                return
            end

            ---@type string
            local name = spec[1]:match("[^/]+$"):gsub("%.", "-")
            local path = "kepler.config." .. name

            if type(spec.config) == "boolean" and spec.config then
                ---@type fun(self:LazyPlugin, opts:table)
                spec.config = function(_) return require(path .. ".config") end
            end

            if type(spec.init) == "boolean" and spec.init then
                ---@type fun(self:LazyPlugin)
                spec.init = function() return require(path) end
            end

            if type(spec.opts) == "boolean" and spec.opts then
                ---@type fun(self:LazyPlugin, opts:table)
                spec.opts = function(_) return require(path .. ".opts") end
            end

            if type(spec.keys) == "boolean" and spec.keys then
                ---@type fun(self:LazyPlugin, keys:string[]):(string | LazyKeysSpec)[]
                ---@diagnostic disable-next-line: assign-type-mismatch
                spec.keys = function(_) return require(path .. ".keys") end
            end

            if type(spec.build) == "boolean" and spec.build then
                ---@type fun(self:LazyPlugin)
                spec.build = function() return require(path .. ".build") end
            end

            return spec
        end)
        :totable()
end
