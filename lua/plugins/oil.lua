return {
    "stevearc/oil.nvim",
    keys = {
        dependencies = { "nvim-tree/nvim-web-devicons" },
        { "g-", function() require("oil").open() end, desc = "Open Oil fil browser" },
    },
    lazy = false,
    opts = {
        keymaps = {
            -- Disabling because I want Telescope to use this
            ["<C-p>"] = false
        }
    }
}


