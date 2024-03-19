-- nvim-lint
-- Async linter for Neovim
-- https://github.com/mfussenegger/nvim-lint

return {
    "mfussenegger/nvim-lint",
    cond = not vim.g.vscode,
    dependencies = {
        -- Additional lua configuration, makes nvim stuff amazing!
        "folke/neodev.nvim",
    },
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    opts = {
        autocmd = {
            events = { "BufEnter", "BufWritePost" },
            pattern = { "*.py", "*.lua", "*.js", "*.ts", },
            linters_by_ft = {
                python = { "mypy" },
            },
        },
        on_demand = {
            linters_by_ft = {
                python = { "mypy", "pylint" },
            },
        },
    },
    config = function(_, opts)
        local lint = require("lint")
        lint.linters_by_ft = {
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
        }

        local function lint_autocmd()
            local filetype = vim.bo.filetype
            local linter_names = opts.autocmd.linters_by_ft[filetype] or {}
            require("lint").try_lint(linter_names)
        end

        local function lint_on_demand()
            local filetype = vim.bo.filetype
            local linter_names = opts.on_demand.linters_by_ft[filetype] or {}
            require("lint").try_lint(linter_names)
        end

        local lint_augroup = vim.api.nvim_create_augroup("user-nvim-lint", { clear = true })
        vim.api.nvim_create_autocmd(opts.autocmd.events, {
            group = lint_augroup,
            pattern = opts.autocmd.pattern,
            callback = lint_autocmd,
        })

        vim.keymap.set("n", "<leader>cl", lint_on_demand, { desc = "[C]ode [l]int" })

        -- Hate to remove this because I was pretty proud of it, but I'm removing
        -- Pylint altogether. Since this is just my code, I'm leaving it here
        -- as a reference if I want to mess with it again later.
        -- -- I use Pylint consistently, and I have some projects that enforce
        -- -- that Pylint must be passing. However, I don't always want to see
        -- -- low-severity Pylint warnings like "missing docstring" for things
        -- -- I'm still actively writing. They can be distracting.
        -- --
        -- -- Build out a simple behavior that switches the Pylint arguments
        -- -- to include or exclude Pylint's complexity (C) and conventions (R)
        -- -- messages.
        -- --
        -- -- I intentionally make this a global user command instead of a
        -- -- buffer-specific one.
        --
        -- local default_pylint_args = vim.deepcopy(lint.linters.pylint.args)
        -- local simple_pylint_args = vim.deepcopy(lint.linters.pylint.args)
        -- table.insert(simple_pylint_args, "--disable=C,R")
        --
        -- local disable_pylint_low_severity = false
        -- local function toggle_pylint_severity_mode()
        --     disable_pylint_low_severity = not disable_pylint_low_severity
        --     if disable_pylint_low_severity then
        --         lint.linters.pylint.args = simple_pylint_args
        --         print("Pylint mode changed to error/warning only")
        --     else
        --         lint.linters.pylint.args = default_pylint_args
        --         print("Pylint mode reset to default")
        --     end
        --     -- Run the linter again to remove leftover messages or restore
        --     -- newly added ones
        --     lint.try_lint()
        -- end
        --
        -- vim.api.nvim_create_user_command("PylintSeverityToggle", toggle_pylint_severity_mode, {})
    end,
}
