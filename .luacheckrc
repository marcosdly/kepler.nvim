return {
    globals = { "vim", "describe", "before_each", "it", "assert" },
    max_line_length = 100,
    unused = false,
    unused_args = false,
    jobs = 2,
    include_files = {
        "init.lua",
        ".luacheckrc",
        "lua",
    },
}
