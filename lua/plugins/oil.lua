-- oil.nvim
-- A file explorer / manager that allows you to edit the filesystem as if
-- it were a regular text buffer
--
-- https://github.com/stevearc/oil.nvim
--


return {
    "stevearc/oil.nvim",
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cond = not vim.g.vscode,
    keys = {
        { "g-", function() require("oil").open() end, desc = "Open Oil fil browser" },
    },
    -- This plugin should replace netrw, so it needs to load immediately
    lazy = false,
    opts = {
        keymaps = {
            ["g?"] = "actions.show_help",
            ["<CR>"] = "actions.select",
            ["<C-s>"] = "actions.select_vsplit",
            ["<C-h>"] = "actions.select_split",
            ["<C-t>"] = "actions.select_tab",
            ["<A-p>"] = "actions.preview",
            ["<C-c>"] = "actions.close",
            ["<C-l>"] = "actions.refresh",
            ["-"] = "actions.parent",
            ["_"] = "actions.open_cwd",
            ["`"] = "actions.cd",
            ["~"] = "actions.tcd",
            ["g."] = "actions.toggle_hidden",
            -- Disable this default since I use this shortcut for Telescope
            ["<C-p>"] = false,
        },

        view_options = {
            show_hidden = true,
        },
    },
    config = true,
    -- config = function(_, opts)
    --     local oil = require("oil")
    --     oil.setup(opts)
    --     vim.keymap.set("n", "<A-e>", oil.open, { desc = "[E]xplore with oil.nvim" })
    -- end
}
