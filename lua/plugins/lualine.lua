return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    cond = not vim.g.vscode,
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    },
    opts = function()
        local icons = require("ibrahim.icons")
        return {
            options = {
                theme = "gruvbox",
                globalstatus = true,
                disabled_filetypes = {
                    statusline = { "lazy" },
                },
            },
            sections = {
                lualine_b = {
                    "branch",
                    {
                        "diagnostics",
                        symbols = {
                            error = icons.diagnostics.Error,
                            warn = icons.diagnostics.Warn,
                            info = icons.diagnostics.Info,
                            hint = icons.diagnostics.Hint,
                        },
                    },
                },
                lualine_c = {
                    {
                        "filetype",
                        icon_only = true,
                        separator = "",
                        padding = { left = 1, right = 0 },
                    },
                    {
                        "filename",
                        path = 1,
                        symbols = {
                            modified = "  ",
                            readonly = "",
                            unnamed = "",
                        },
                    },
                },
                lualine_x = {
                    {
                        "diff",
                        symbols = {
                            added = icons.git.added,
                            modified = icons.git.modified,
                            removed = icons.git.removed,
                        },
                    },
                },
            },
        }
    end,
}
