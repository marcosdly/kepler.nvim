local oil = require "oil"
local size_ratio = 0.6 -- Percentage

oil.setup {
    buf_options = {
        buflisted = false,
        bufhidden = "hide",
    },
    float = {
        padding = 2,
        win_options = {
            winblend = 0,
            cursorline = true,
            cursorlineopt = "line,number",
            wrap = false,
            list = false,
            spell = false,
        },
        override = function(conf)
            conf.width = math.ceil(vim.o.columns * size_ratio)
            conf.height = math.ceil(vim.o.lines * size_ratio)
            conf.relative = "editor"
            conf.anchor = "NW" -- top left (northwest)
            return conf
        end,
    },
    preview = {
        width = 0.5,
        height = 0.9,
    },
    columns = {
        "permissions",
        "size",
        "mtime",
        "icon",
    },
    keymaps = {
        -- *Extending defaults*
        ["<C-s>"] = "<cmd>write<cr>", -- Capital 'C' cuz that's the default
        ["<C-v>"] = "actions.select_vsplit",
        ["/"] = "actions.parent",
        ["<space>"] = "actions.select",
    },
}
