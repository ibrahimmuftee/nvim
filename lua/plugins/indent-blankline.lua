return {
    "lukas-reineke/indent-blankline.nvim",
    cond = not vim.g.vscode,
    -- https://github.com/lukas-reineke/indent-blankline.nvim/wiki/Migrate-to-version-3
    main = "ibl",
    config = function()
        -- Still playing with settings for these
        -- Enable it to show whitespace, newline characters, etc.
        -- vim.opt.list = true
        -- vim.opt.listchars:append("space:⋅")
        -- vim.opt.listchars:append("eol:↴")

        -- Add the "oil" filetype to exclusions to prevent an error
        vim.g.indent_blankline_filetype_exclude = {
            "lspinfo",
            "packer",
            "checkhealth",
            "help",
            "man",
            "oil",
            "",
        }

        require("ibl").setup({
            whitespace = {
                remove_blankline_trail = false,
            },
        })
    end,
}
