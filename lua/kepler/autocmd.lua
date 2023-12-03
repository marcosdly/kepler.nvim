local autocmd = vim.api.nvim_create_autocmd

-- Clear command line
vim.fn.timer_start(4e3, function() print " " end, { ["repeat"] = -1 })

local function handle_useless_buffers()
    -- Can't figure out what I had in mind to do this instead of a
    -- plugin. Maybe cuz I'm kinda excited about autocmds.
    -- I'll probrably switch a lot of this autocmds to plugins,
    -- eventually. For now, it's cool to have my code doing stuff.
    local original_buffer = vim.api.nvim_get_current_buf()
    vim.iter(vim.api.nvim_list_bufs()):each(function(bufnr)
        if
            not vim.api.nvim_buf_get_option(bufnr, "buflisted")
            or vim.api.nvim_buf_get_name(bufnr) ~= ""
        then
            return
        end
        -- Wouldn't work if you're not on your local machine
        -- if select(1, vim.loop.fs_stat(vim.api.nvim_buf_get_name(bufnr))) then
        --     do break end
        -- end

        if vim.api.nvim_buf_get_option(bufnr, "buftype") == "" then
            vim.api.nvim_buf_delete(bufnr, { force = false })
            return
        end

        vim.cmd("noautocmd keepalt buffer " .. tostring(bufnr))
        local wordcount = vim.fn.wordcount()
        vim.cmd("noautocmd keepalt buffer " .. tostring(original_buffer))

        if wordcount.bytes == 0 or wordcount.chars == 0 then
            vim.api.nvim_buf_delete(bufnr, { force = false })
            return
        end
        if
            vim.iter(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false))
                :all(function(line) return line == "" or line:match " +" == line end)
        then
            vim.api.nvim_buf_delete(bufnr, { force = false })
            return
        end
    end)
end

-- Delete useless buffers
autocmd("BufReadPost", {
    desc = "Check for useless buffers and deletes them.",
    callback = handle_useless_buffers,
})
