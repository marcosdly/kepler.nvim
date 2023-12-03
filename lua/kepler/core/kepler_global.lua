--[[
    KeplerFn layout:
        KeplerFn .. [Pascal case function name] .. [Pascal case parameter name]

        With the underscore "_" as a separator, e.g. KeplerFn_StdPath_Mode. This
        does not imply how the actual function or parameter names will be written.

        Forcing case compliance on compound words in function/parameter names is
        encouraged, unless that compound word is formally part of the english
        language, which will make case compliance feel unnatural. For instance:
            - UpSide
            - UnNatural
            - BackPack
            - LogIn
            - CheckOut
--]]

--  luacheck: no unused args
--- @diagnostic disable: unused-local

---@class KeplerDebugOption
---@field value any?
---@field enabled boolean
---@field get fun(default: any?):any Return the option's value if enabled or `default` if it isn't.

--- KeplerDebugOption constructor.
---@return KeplerDebugOption
local function kepler_debug_option()
    local meta = {
        __newindex = function(table, key, value)
            if key == "value" then
                rawset(table, key, value)
                return
            end
            if key == "enabled" and type(value) == "boolean" then
                rawset(table, key, value)
                return
            else
                error "Key 'enabled' must be a boolean"
            end
            error(string.format("Key '%s' cannot exist", key))
        end,
    }
    local T = { enabled = false }
    ---@param default any Value to return if option is disabled. Triggers events automatically.
    ---@return any
    function T:get(default)
        if self.enabled then return self.value end
        return default
    end
    return setmetatable(T, meta)
end

---@class KeplerDebugOptionEvent
---@field config KeplerDebug Mutable reference to `kepler.debug`.
---@field option KeplerDebugOption Mutable reference to the option that triggered the event.
---@field path string Period separated, table path without the `"kepler.debug."` prefix.

---@class KeplerVimGlobal
local kepler = setmetatable({
    bootstrap = {
        ---@type boolean
        first_start = false,
    },
    ---@class KeplerDebug
    debug = {
        ---@type boolean
        enable_all = false,
        -- events = {
        --     -- Dummy if statements to shut lua_ls
        --
        --     ---@param event KeplerDebugOptionEvent
        --     ---@return any
        --     on_debug_option_before = function(event) end,
        --     ---@param event KeplerDebugOptionEvent
        --     ---@return any
        --     on_debug_option_after = function(event) end,
        --     ---@param event KeplerDebugOptionEvent
        --     ---@param err string
        --     ---@return any
        --     on_debug_option_error = function(event, err) end,
        --     ---@param err string
        --     ---@return any
        --     on_kepler_error = function(err) end,
        -- },
        resolution_root_dir = {
            ---@type KeplerDebugOption
            typping = kepler_debug_option(),
            ---@type KeplerDebugOption
            lazynvim = kepler_debug_option(),
            ---@type KeplerDebugOption
            nvimconf = kepler_debug_option(),
        },
    },
    -- lib = {
    -- These imports need to actually work for lua_ls to annotate them. If
    -- you're not hacking nvim config directly their typing info will not
    -- be seemlessly updated.
    -- penlight = require "kepler.lib.pl",
    -- plenary = require "kepler.lib.plenary",
    -- },
    fn = require "kepler.core.builtin.fn",
}, { __newindex = function(...) end })

if _G.kepler then
    _G.kepler = vim.tbl_deep_extend("keep", kepler, _G.kepler)
    return
end

_G.kepler = kepler
