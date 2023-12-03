local cmdheight = { normal = 1, extended = 2 }

vim.iter(pairs {
    -- Formatting
    shiftwidth = 4,
    tabstop = 4,
    autoindent = true,
    autoread = false,
    autowriteall = true,
    copyindent = true,
    expandtab = true,
    shiftround = true,
    smartindent = true,
    -- UI Features
    number = true,
    relativenumber = true,
    background = "dark",
    cursorcolumn = false,
    cursorline = true,
    cursorlineopt = "number,line",
    scrolloff = 5,
    emoji = true,
    linebreak = true,
    list = true,
    menuitems = 20,
    mouse = "",
    showcmd = false,
    showcmdloc = "statusline",
    termguicolors = true,
    guicursor = "n-o-c-sm:block,ve-i-r-ci-cr:ver25,a:blinkwait1000-blinkon80-blinkoff80-Cursor/lCursor",
    -- Vim Internals
    cdhome = false,
    clipboard = "unnamedplus",
    cmdheight = cmdheight.normal,
    completeopt = "menu,menuone,noinsert",
    confirm = true,
    wildignorecase = true,
    ignorecase = true,
    wildmenu = true,
    hlsearch = true,
    undofile = true,
    smartcase = true,
    shortmess = "mrwoOTsWAIcCF",
    -- TODO research the following options:
    -- See shell*
    -- See scroll*
    -- See format*
    -- See fold*
    -- See inc*
    -- See im*
}):each(function(k, v) vim.o[k] = v end)

-- Insert* events will be triggered only on insert mode rather than visual and replace modes
vim.v.insertmode = "i"

-- EditorConfig
vim.g.editorconfig = true

vim.api.nvim_create_autocmd("InsertEnter", {
    desc = "Disable relative numbers while editing.",
    command = "set norelativenumber",
})
vim.api.nvim_create_autocmd("InsertLeave", {
    desc = "Enable relative numbers outside editing.",
    command = "set relativenumber",
})
vim.api.nvim_create_autocmd("CmdlineEnter", {
    desc = "Expand command line.",
    callback = function()
        vim.o.cmdheight = cmdheight.extended
        -- If cmdheight > 1 the prompt will appear at the bottom and shift
        -- up at first input. That works, but redrawing the screen fixes it.
        vim.cmd.redraw()
    end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
    desc = "Hide command line.",
    command = "set cmdheight=" .. tostring(cmdheight.normal), -- No need to redraw
})
