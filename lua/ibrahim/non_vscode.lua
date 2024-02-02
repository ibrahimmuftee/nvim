-- non_vscode.lua
--
-- Settings that should not be loaded in VSCode (mostly keymaps)

if vim.g.vscode then
    print("WARNING: Tried to load non_vscode.lua from an instance connected to VSCode")
    return
end

local function map(mode, left, right, opts)
    local default_opts = {
        noremap = true,
        silent = true,
    }
    opts = opts or {}
    -- "keep" mode preserves the values from the leftmost table,
    -- so prioritize any options provided over the defaults
    local full_opts = vim.tbl_extend("keep", opts, default_opts)
    vim.keymap.set(mode, left, right, full_opts)
end

