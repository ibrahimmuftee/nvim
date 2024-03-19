return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    cond = not vim.g.vscode,
    dependencies = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    },
    opts = function()
        local icons = require("ibrahim.icons")
        return {
            options = {
                theme = "auto",
                -- theme = "catppuccin",
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
                        -- LSP servers
                        function()
                            local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                            local clients = vim.lsp.get_active_clients()
                            if next(clients) == nil then
                                return ""
                            end
                            local client_names = {}
                            for _, client in ipairs(clients) do
                                local filetypes = client.config.filetypes
                                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                                    -- return client.name
                                    table.insert(client_names, client.name)
                                end
                            end
                            return table.concat(client_names, "|")
                        end,
                        icon = '',
                    },
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
            winbar = {
                lualine_b = {
                    {
                        "filename",
                        path = 0,
                        file_status = false,
                    },
                },
                lualine_c = {
                    {
                        "navic",
                        color_correction = "dynamic",
                        navic_opts = nil,
                    },
                },
            },
            inactive_winbar = {
                lualine_c = {
                    {
                        "filename",
                        path = 0,
                        file_status = false,
                    },
                },
            },
        }
    end,
}
