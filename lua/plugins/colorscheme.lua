-- Disabled for now as I continue to use Nightfox.
-- However, I'm keeping it around in case I change my mind.
return {
    "catppuccin/nvim",
    name = "catppuccin",
    cond = not vim.g.vscode,
    priority = 1000,
    opts = {
        transparent_background = true,
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        integrations = {
            cmp = true,
            gitsigns = true,
            mason = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                },
                inlay_hints = {
                    background = true,
                },
            },
            navic = {
                enabled = true,
                custom_bg = "NONE",
            },
            nvimtree = true,
            treesitter = true,
        },
    },
    config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
    end,
}
