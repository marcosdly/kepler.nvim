return {
    {
        "<leader>e",
        function() require("oil").toggle_float() end,
        desc = "File Manager on buffer's dir",
    },
    {
        "<leader>E",
        function() require("oil").toggle_float(vim.fn.getcwd()) end,
        desc = "File Manager on working dir",
    },
}
