-- octo.nvim
-- Neovim wrapper around the `gh` CLI tool
-- https://github.com/pwntester/octo.nvim
--
-- In Lua, only false and nil are "falsey" - the number zero is still
-- truthy in a conditional. See :help executable for details on the
-- vim.fn.executable, but it returns 0 if the given command is not found
-- on the current PATH.

return {
    "pwntester/octo.nvim",
    cond = not vim.g.vscode and (vim.fn.executable("gh") == 1),
    cmd = "Octo",
    event = "VeryLazy",
    requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    config = true,
}
