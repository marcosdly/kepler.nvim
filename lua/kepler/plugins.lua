-- See lazy.nvim plugin spec at https://github.com/folke/lazy.nvim#-plugin-spec

---@class KeplerUserPlugin: LazyPluginSpec
---@field config boolean?
---@field init boolean?
---@field opts boolean?
---@field keys boolean?
---@field build boolean?

return {
    -- Color Scheme
    {
        "xiyaowong/transparent.nvim", -- nice to have; won't write my own
        cmd = { "TransparentEnable", "TransparentDisable", "TransparentToggle" },
        event = true and "VimEnter", -- toggle bool to enable on startup
        keys = {
            {
                "<leader>ot",
                "<cmd>TransparentToggle<cr>",
                desc = "Toggle transparent background",
            },
        },
    },
    {
        "NTBBloodbath/doom-one.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.iter(pairs {
                cursor_coloring = true,
                terminal_colors = true,
                italic_comments = false,
                diagnostics_text_color = false,
                transparent_background = false,
                enable_treesitter = true,
                plugin_telescope = true,
                plugin_indent_blankline = true,
                plugin_vim_illuminate = true,
            }):each(function(k, v) vim.g["doom_one_" .. k] = v end)

            vim.cmd.colorscheme "doom-one"
        end,
    },
    -- File manager
    {
        -- File Manager
        "stevearc/oil.nvim",
        config = true,
        keys = true,
    },
    -- Formatting
    {
        "mhartington/formatter.nvim",
        config = true,
        event = "BufWritePre",
        cmd = { "Format", "FormatLock", "FormatWrite", "FormatWriteLock" },
        keys = {
            { "<leader>af", "<cmd>Format<cr>", desc = "Format active buffer" },
            {
                "<leader>aF",
                "<cmd>FormatWrite<cr>",
                desc = "Format and write active buffer",
            },
        },
    },
    -- LSP
    {
        "VonHeikemen/lsp-zero.nvim",
        config = true,
        lazy = false,
        dependencies = {
            "neovim/nvim-lspconfig",
            "folke/neodev.nvim",
            "folke/neoconf.nvim",
            {
                "williamboman/mason.nvim",
                dependencies = { "williamboman/mason-lspconfig.nvim" },
            },
            {
                "hrsh7th/nvim-cmp",
                dependencies = {
                    "FelipeLema/cmp-async-path",
                    "rcarriga/cmp-dap",
                    "hrsh7th/cmp-nvim-lsp",
                    "hrsh7th/cmp-nvim-lua",
                    "hrsh7th/cmp-calc",
                    "hrsh7th/cmp-cmdline",
                    "L3MON4D3/LuaSnip",
                },
            },
        },
    },
    {
        -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        config = true,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-context",
        },
        build = ":TSUpdate",
    },
    -- Debug
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
        },
    },
    -- Utilities
    {
        "numToStr/Comment.nvim",
        -- Lazy load even on unammed/dummy buffers
        event = { "BufEnter", "InsertLeave", "TextChanged" },
        opts = {
            padding = true,
            sticky = true,
            mapping = { basic = true, extra = true },
            -- Use default mappings. Just this tiny ajustment:
            extra = { eol = "gca" },
        },
    },
    {
        "RRethy/vim-illuminate",
        event = { "BufEnter", "InsertLeave", "TextChanged" },
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        -- TODO Check out FastWrap eventually (too minor stuff to have more keymaps for, as of now)
        opts = { enable_check_bracket_line = false },
    },
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        config = true,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-lua/plenary.nvim",
            "BurntSushi/ripgrep",
            "nvim-telescope/telescope-fzf-native.nvim",
            "sharkdp/fd",
        },
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = {},
    },
    -- UI
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufEnter", "InsertLeave", "TextChanged" },
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help ibl`
        main = "ibl",
        opts = {},
    },
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        config = true,
        dependencies = {
            "arkav/lualine-lsp-progress",
        },
    },
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        opts = {
            auto_close = true,
            auto_fold = true,
            use_diagnostic_signs = true,
            icons = false,
        },
        keys = {
            {
                "<leader>T",
                function() require("trouble").toggle "document_diagnostics" end,
                desc = "Document diagnostics",
            },
            {
                "<leader>t",
                function() require("trouble").toggle "workspace_diagnostics" end,
                desc = "Workspace diagnostics",
            },
        },
    },
    --[[ {
        "smoka7/multicursors.nvim",
        event = "VeryLazy",
        dependencies = { "smoka7/hydra.nvim" },
        cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
        keys = {
            {
                mode = { "v", "n" },
                "<Leader>m",
                "<cmd>MCstart<cr>",
                desc = "Create a selection for selected text or word under the cursor",
            },
        },
    }, ]]
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = "VeryLazy",
        -- Adjust colors for doom-one tone (colorful but glowing-colorful)
        config = function() require("rainbow-delimiters.setup").setup {} end,
    },
    -- TODO config treesitter keymaps
    -- TODO normalize terminal input (tmux?)
    -- TODO buffer navigation
    -- TODO config dap ui
    -- TODO config dap ui launch.json import
    -- TODO lazygit
    -- TODO OPTIONAL git signs
    -- TODO maybe new colorscheme?
    -- TODO inner terminal
    -- TODO block toggler
    -- TODO playground files
    -- TODO harpoon
    -- TODO sessions
    -- TODO Check out options to remove all useless text below status line
    --
    -- TODO MYNE oil.nvim preview files
    -- TODO MYNE oil.nvim preview dir tree as project drawer
    -- TODO MYNE action navigator like vscode
    -- TODO MYNE rich keymap navigator
}
