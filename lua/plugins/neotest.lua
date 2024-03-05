return {
    "nvim-neotest/neotest",
    cond = not vim.g.vscode,
    ft = { "python" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python",
    },
    opts = function()
        return {
            adapters = {
                require("neotest-python")({
                    -- Use the current Python binary on the path.
                    -- This will usually be a virtual environment.
                    python = "python",
                    runner = "pytest",
                    is_test_file = function(file_path) ---@param file_path string
                        -- I place all of my Python test files in a
                        -- `tests` directory, and they all start with
                        -- `test_` per Pytest conventions.
                        local normalized_path = vim.fs.normalize(file_path)
                        return normalized_path:match("tests/.*%/test_.*%.py$") ~= nil
                    end,
                }),
            },
        }
    end,
    config = function(_, opts)
        require("neotest").setup(opts)

        vim.keymap.set({ "n" }, "<leader>tr", require("neotest").run.run, { desc = "Neotest: run test at cursor" })
        vim.keymap.set({ "n" }, "<leader>tf", function()
            require("neotest").run.run(vim.fn.expand("%"))
        end, { desc = "Neotest: run all tests in current file" })
        vim.keymap.set({ "n", }, "<leader>ts", require("neotest").summary.toggle, { desc = "Neotest: toggle summary panel" })
    end,
}
