local zero, cmp, lspconf = require "lsp-zero", require "cmp", require "lspconfig"
local diag, buf = vim.diagnostic, vim.lsp.buf

require("neodev").setup {
    library = {
        enabled = true,
        runtime = true,
        types = true,
    },
    setup_jsonls = true,
    lsconfig = true,
    -- lua-language-server >= 3.6.0
    pathStrict = true,
}

require("neoconf").setup {
    import = { vocode = true },
    live_reload = true,
    filetype_jsonc = true,
}

zero.on_attach(function(client, bufnr)
    -- Disable formatting provided by language server by default
    -- (they're usually not good, personally).
    -- NOTE Use Formatter.nvim plugin to configure formatters.
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentFormattingRangeProvider = false

    local opts = { silent = true, noremap = true, nowait = true, buffer = bufnr }
    local normal_mode = vim.iter({
        { "gd", buf.definition, "Jump to definition" },
        { "gdd", buf.declaration, "Jump to declaration" },
        { "gi", buf.implementation, "List symbol implementations" },
        { "gt", buf.type_definition, "Jump to type definition of symbol" },
        { "ga", buf.code_action, "View code actions" },
        { "gr", buf.references, "List references" },
        { "gl", buf.incoming_calls, "List symbol call sites" },
        { "go", buf.outgoing_calls, "List symbols called by selected symbol" },
        { "<leader>g", diag.open_float, "Peek diagnostics for current line" },
        { "gs", buf.workspace_symbol, "List symbols across workspace" },
        { "<leader>ar", buf.rename, "Rename all occurrences of symbol" },
        { "K", buf.hover, "Symbol info (floating)" },
        { "[d", diag.goto_prev, "Jump to previous diagnostic" },
        { "]d", diag.goto_next, "Jump to next diagnostic" },
    })
        :map(function(mapping)
            table.insert(mapping, 1, "n")
            return mapping
        end)
        :totable()

    -- No particular mode category
    local general = {
        {
            { "i", "n" },
            "<c-;>",
            buf.signature_help,
            "Symbol details (floating)",
        },
    }

    vim.list_extend(general, normal_mode)

    require "kepler.core.setup.keymap" { [opts] = general }
end)

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls" },
    handlers = {
        zero.default_setup,
        lua_ls = function() lspconf.lua_ls.setup(zero.nvim_lua_ls()) end,
    },
}

local cmp_select = { behaviour = cmp.SelectBehavior.Select }
local cmp_basic_keys = {
    ["<c-,>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<c-.>"] = cmp.mapping.select_next_item(cmp_select),
    -- <C-M> may send a <CR> instead
    -- See: https://vi.stackexchange.com/questions/3225/disable-esc-but-keep-c
    -- Same as Ctrl+/
    ["<C-Char-47>"] = cmp.mapping.confirm {
        ["select"] = true,
        behaviour = cmp.ConfirmBehavior.Replace,
    },
    ["<c-Space>"] = cmp.mapping.complete(),
}

cmp.setup {
    enabled = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local context = require "cmp.config.context"
        if context.in_treesitter_capture "comment" or context.in_syntax_group "comment" then
            return false
        end
        -- require"cmp_dap".is_dap_buffer()
        return true
    end,
    sources = {
        -- Always active
        { name = "async_path" },
        { name = "calc" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
    },
    formatting = zero.cmp_format(),
    mapping = cmp.mapping.preset.insert(cmp_basic_keys),
    view = {
        entire = "custom",
        selection_order = "near_cursor",
        docs = {
            auto_open = true,
        },
    },
    window = {
        completion = {
            border = "rounded",
            scrolloff = 2,
            col_offset = 1,
            scrollbar = true,
        },
        documentation = { border = "rounded" },
    },
    experimental = { ghost_text = true },
    completion = {
        -- autocomplete = false,
        completeopt = "menu,menuone,noinsert",
    },
}

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
        { name = "dap" },
    },
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(cmp_basic_keys),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
    }),
})

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(cmp_basic_keys),
    sources = {
        { name = "buffer" },
    },
})
