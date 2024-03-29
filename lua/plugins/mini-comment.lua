return {
    "echasnovski/mini.comment",
    cond = not vim.g.vscode,
    version = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    event = "VeryLazy",
    opts = {
        hooks = {
            pre = function()
                require("ts_context_commentstring.internal").update_commentstring({})
            end,
        },
    },
    config = function(_, opts)
        -- I'm not sure why this is requireed. I thought Lazy.nvim didn't require the
        -- config key if the only line in the function was to call setup().
        -- However, without this key, this plugin fails to load with the error
        -- "mini" could not be found
        require("mini.comment").setup(opts)
    end,
}
