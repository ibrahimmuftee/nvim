return {
    "stevearc/dressing.nvim",
    cond = not vim.g.vscode,
    opts = function()
        return {
            select = {
                telescope = require("telescope.themes").get_cursor(),
            },
        }
    end,
}
