local opts = {
    logging = true,
    log_level = vim.log.levels.ERROR,
    filetype = {
        lua = { require("formatter.filetypes.lua").stylua },
        python = { require("formatter.filetypes.python").ruff },
        ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespaces,
        },
    },
}

require("formatter").setup(opts)

-- NOTE Use 'FormatterPre' and 'FormatterPost' events to avoid interference.
vim.api.nvim_create_autocmd("BufWritePost", {
    -- Block buffer until done similar to a Mutex Lock
    command = "FormatWrite",
    desc = "Formats file after save",
})
