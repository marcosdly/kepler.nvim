local lazypath = kepler.fn.stdpath "lazy" .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end

vim.opt.rtp:prepend(lazypath)

local lazy = require "lazy"

local config = {
    root = kepler.fn.stdpath "lazy",
    defaults = { lazy = true },
    lockfile = kepler.fn.stdpath "state" .. "/lazy/lock.json",
    ui = {
        border = "rounded",
        title = "lazy.nvim Package Manager",
        pills = true,
    },
    readme = { root = kepler.fn.stdpath "state" .. "/lazy/readme" },
    state = kepler.fn.stdpath "state" .. "/lazy/state.json",
    install = { missing = true },
}

do
    local ok, core = pcall(require, "kepler.core.plugins.core_plugins")
    if not ok then error(core) end
    local setup_plugins = require "kepler.core.setup.plugins"
    local _, additional = xpcall(require, function(_) return {} end, "kepler.plugins")
    vim.list_extend(core, setup_plugins(additional))
    local _, user = xpcall(require, function(_) return {} end, "kepler.user.plugins")
    vim.list_extend(core, setup_plugins(user))
    -- Can't figure out how to make { import = "module" } work for now.
    lazy.setup(core, config)
end
