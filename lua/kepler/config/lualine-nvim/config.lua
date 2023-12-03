local function search()
    if vim.v.hlsearch == 0 then return "[None]" end

    local searchcount = vim.fn.searchcount { maxcount = 999999 }
    return string.format("%s [%s/%s]", vim.fn.getreg "/", searchcount.current, searchcount.total)
end

--- Yes, global state. For now it's contained, I swear.
---@type string
local buf_count

local function update_buf_count()
    -- This is really the more efficient way to do this.
    -- Felt nasty to push declarative mentality into this one.
    local count = 0
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
        -- TODO Make a function that identifies if the file is empty, like the buffer deletion job
        if
            vim.api.nvim_buf_get_option(bufnr, "buflisted") and (buftype == "help" or buftype == "")
        then
            count = count + 1
        end
    end

    buf_count = tostring(count)
end

local function howmany_bufs() return buf_count end

local lualine = require "lualine"

lualine.setup {
    options = {
        icons_enabled = false,
        theme = "auto",
    },
    sections = {
        lualine_a = {
            howmany_bufs,
            "mode",
        },
        lualine_c = {
            "filename",
            "lsp_progress",
        },
        lualine_x = {
            search,
            "encoding",
            "fileformat",
            "filesize",
            "filetype",
        },
    },
    extensions = {
        -- "trouble",
        -- "nvim-dap-ui",
        "quickfix",
    },
}

-- Listen to lsp-progress event and refresh
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lualine_augroup",
    pattern = "LspProgressStatusUpdated",
    callback = lualine.refresh,
})
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "BufAdd", "BufDelete" }, {
    group = "lualine_augroup",
    callback = lualine.refresh,
})
vim.api.nvim_create_autocmd("BufEnter", {
    group = "lualine_augroup",
    callback = update_buf_count,
    once = true,
})
vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
    group = "lualine_augroup",
    callback = update_buf_count,
})
