--- Takes a simplified version of `vim.keymap.set` and set them as keymaps.
---#param keys table<table<string, boolean>, { string|string[], string, string|function, string }>
return function(keys)
    vim.iter(pairs(keys)):each(function(k, maps)
        for _, v in ipairs(maps) do
            if type(v[4]) == "string" then
                v[4] = vim.tbl_extend("keep", k, { desc = v[4] })
            else
                error "Type of the fourth value in a key mapping must be 'string'"
            end
            vim.keymap.set(unpack(v))
        end
    end)
end
