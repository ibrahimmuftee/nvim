-- lsp_lines
--
-- A neat little plugin that shows diagnostics as separate lines instead of
-- virtual text at the end of each line. This makes it easier to read.

return {
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cond = not vim.g.vscode,
    keys = {
        -- The keys table here supports anything in the opts table for
        -- vim.keymap.set, but be careful not to nest it in another table
        -- like you would for that function.
        -- { "<leader>di", desc = "Toggle [d]iagnostic [i]nline" },
        "<leader>di",
    },
    opts = {
        enabled = {
            virtual_lines = true,
            virtual_text = false,
        },
        disabled = {
            virtual_lines = false,
            virtual_text = { spacing = 4, prefix = "●" },
        },
    },
    config = function(_, opts)
        require("lsp_lines").setup()
        local is_enabled = true
        vim.diagnostic.config(opts.enabled)

        vim.keymap.set("n", "<leader>di", function()
            is_enabled = not is_enabled
            if is_enabled then
                vim.diagnostic.config(opts.enabled)
            else
                vim.diagnostic.config(opts.disabled)
            end
        end, { desc = "Toggle [d]iagnostics [i]nline" })
    end,
}
