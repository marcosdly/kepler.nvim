local builtin = require "telescope.builtin"

require("telescope").setup {}

require "kepler.core.setup.keymap" {
    [{ silent = true, nowait = true }] = vim.iter({
        {
            "b",
            builtin.buffers,
            "Search buffers.",
        },
        {
            "d",
            builtin.diagnostics,
            "Search diagnostics.",
        },
        {
            "f",
            builtin.find_files,
            "Search through files in workspace.",
        },
        {
            "g",
            builtin.live_grep,
            "Grep every file in workspace.",
        },
        {
            "h",
            builtin.oldfiles,
            "Search recentily opened files.",
        },
        {
            "u",
            builtin.git_status,
            "Search git status.",
        },
        {
            "s",
            builtin.grep_string,
            "Grep string under the cursor.",
        },
        {
            ":",
            builtin.commands,
            "Run a vim command.",
        },
        {
            "c",
            builtin.command_history,
            "Search through vim's comamnd history.",
        },
    })
        :map(function(map)
            table.insert(map, 1, "n")
            map[2] = "<leader>f" .. map[2]
            return map
        end)
        :totable(),
}
