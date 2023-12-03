--- Disable Buffer highlighting if it is bigger that this amount
---@type number
local max_buf_size = 100 * 1024

require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "vim", "vimdoc", "luadoc", "luap", "json", "jsonc" },
    ignore_install = { "luau" },
    modules = {},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        disable = function(lang, buf)
            local ok, stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_buf_size then
                vim.api.nvim_buf_set_option(buf, "syntax", false)
                return true
            end
        end,
        additional_vim_regex_highlighting = false,
        custom_captures = {
            TODO = "Keyword",
            FIXME = "Keyword",
            NOTE = "Keyword",
        },
    },
    indent = { enable = true },
}

require("treesitter-context").setup {
    enable = true,
    line_numbers = true,
    multiline_threshold = 10, -- How many contexts at once maximum
    trim_scope = "outer", -- If there's more contexts, hide the exceeding topmost ones
    min_window_height = 25,
}

-- TODO Check if this can remain, e.g. figure treesitter mapping out first
--vim.keymap.set("n", "gK", function() require"treesitter-context".go_to_context() end, { silent = true })
