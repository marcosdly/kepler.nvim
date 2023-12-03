--[[
    See :help :map-commands

    lhs      left-hand-side      What you want to press.
    rhs      right-hand-side     What you want to happen.

    See :help :map-arguments

    silent   Don't log mapping when executed.
    nowait   Execute mapping right away, don't expect more input.
    unique   Throw an error if mapping has already been defined.
    noremap  Make `lhs` synonym to `rhs` and prevent `rhs` from being used ever again.
    buffer   Mapping will only work on given buffer.

    See :help map-overview

    n        Normal
    v        Visual and Select
    s        Select
    x        Visual
    o        Operator-pending
    i        Insert
    l        Insert, Command-line, Lang-Arg
    c        Command-line
    t        Terminal
--]]

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

require "kepler.core.setup.keymap" {
    [{ nowait = true, unique = true, silent = true }] = {
        -- Window
        {
            "n",
            "<c-h>",
            "<c-w>h",
            "Move to window on the LEFT.",
        },
        {
            "n",
            "<c-j>",
            "<c-w>j",
            "Move to window on the BOTTOM.",
        },
        {
            "n",
            "<c-k>",
            "<c-w>k",
            "Move to window on the TOP.",
        },
        -- Buffer
        {
            "n",
            "<leader>bd",
            "<cmd>bdelete<cr>",
            "Delete active buffer.",
        },
        {
            "n",
            "<leader>bD",
            "<cmd>bdelete<cr>",
            "Delete active buffer without saving.",
        },
        {
            "n",
            "<leader>bn",
            "<cmd>bnext<cr>",
            "Go to next buffer.",
        },
        {
            "n",
            "<leader>bN",
            "<cmd>bnext!<cr>",
            "Go to next buffer (no saving).",
        },
        {
            "n",
            "<leader>bp",
            "<cmd>bprev<cr>",
            "Go to previous bugger.",
        },
        {
            "n",
            "<leader>bP",
            "<cmd>bprev!<cr>",
            "Go to previous buffer (no saving).",
        },
        {
            { "n", "v", "i", "o" },
            "<c-s>",
            "<cmd>write<cr>",
            "Save current active buffer.",
        },
        {
            "n",
            "<leader><c-s>",
            "<cmd>wall<cr>",
            "Save every buffer.",
        },
        {
            "n",
            "<leader>ZZ",
            "<cmd>qall<cr>",
            "Exit Neovim.",
        },
        -- {
        --     "n",
        --     "<leader>ZZZ",
        --     ":qall!",
        --     "Exit Neovim without saving anything.",
        -- },
    },
    [{ nowait = true, silent = true }] = {
        {
            "n",
            "<c-l>",
            "<c-w>l",
            "Move to window on the RIGHT.",
        },
        {
            "n",
            "<leader>h",
            "<cmd>nohl<cr>",
            "Clear search highlights",
        },
    },
    [{ nowait = true, silent = true, noremap = true }] = {
        {
            { "n", "i", "v" },
            "<c-d>",
            "<c-d>zz",
            "Move cursor DOWN by half screen height.",
        },
        {
            { "n", "i", "v" },
            "<c-u>",
            "<c-u>zz",
            "Move cursor UP by half screen height.",
        },
    },
    [{ nowait = true, expr = true, silent = true }] = {
        {
            "n",
            "k",
            "v:count == 0 ? 'gk' : 'k'",
            "Go up by 1 line (wrap aware).",
        },
        {
            "n",
            "j",
            "v:count == 0 ? 'gj' : 'j'",
            "Go down by 1 line (wrap aware).",
        },
    },
}
