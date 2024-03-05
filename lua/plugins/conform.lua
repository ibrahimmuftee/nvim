-- Use prettierd if it's available or prettier otherwise, but don't
-- try to run them both.
local prettier = { { "prettierd", "prettier" } }

return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo", "Format" },
    opts = {
        formatters = {
            sqlfluff = {
                -- By default, SQLFluff uses "ansi" formatting. My projects
                -- right now use MySQL formatting instead.
                -- Still looking for a better way to manage this.
                args = { "fix", "--force", "--dialect=mysql", "-" },
            },
        },
        formatters_by_ft = {
            lua = { "stylua" },

            -- Ruff LSP handles formatting for Python code
            -- -- Multiple items in one table will be run sequentially
            -- python = { "ruff_format", "black" },

            css = prettier,
            html = prettier,
            javascript = prettier,
            json = prettier,
            markdown = prettier,
            typescript = prettier,
            yaml = prettier,

            sql = { "sqlfluff" },
        },
    },
    config = function(_, opts)
        local conform = require("conform")
        require("conform").setup(opts)

        local function format()
            conform.format({ async = true, lsp_fallback = true })
        end

        vim.keymap.set({ "n", "v" }, "<leader>rf", format, { desc = "Reformat" })
        vim.api.nvim_create_user_command("Format", format, {})
    end,
}
