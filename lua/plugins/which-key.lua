-- which-key
-- https://github.com/folke/which-key.nvim
--
-- Shows a popup window with key bindings when the native vim
-- timeout length has expired.
--
-- I go back and forth on whether I like this plugin, but right now I
-- think it's nice as an occasional referenc for stuff I don't use
-- frequently.

return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        vim.opt.timeout = true
        vim.opt.timeoutlen = 1000
        local wk = require("which-key")
        wk.setup({
            window = {
                border = "double",
                position = "bottom",
                margin = { 1, 0, 1, 0 },
                padding = { 3, 2, 3, 2 },
                winblend = 20,
            },
            layout = {
                height = { min = 4, max = 25 },
                width = { min = 20, max = 50 },
                spacing = 8,
                align = "center",
            },
        })
        wk.register({
            ["<leader>"] = {
                c = { name = "+code / clipboard" },
                d = { name = "+diagnostics" },
                s = { name = "+search" },
            },
        })
    end
}
