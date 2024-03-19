-- Mason.nvim
-- Package manager for LSP servers, linters, etc. for nvim
-- https://github.com/williamboman/mason.nvim
--
-- I choose not to use mason_lspconfig. My language servers are configured
-- in nvim-lspconfig.lua, which is already a complex enough file without
-- adding Mason and tool installation to the mix.

return {
    "williamboman/mason.nvim",
    cond = not vim.g.vscode,
    dependencies = {
        -- "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        require("mason").setup({
            -- If executables are found in the path already, prefer them over
            -- anything Mason installs. This makes things like Python virtual
            -- environments work more smoothly.
            PATH = "append",
        })

        require("mason-tool-installer").setup({
            ensure_installed = {
                -- mason-tool-installer uses names as defined in Mason.
                -- This is not necessarily the same name as found in lspconfig.
                -- See this doc for the translation / mapping:
                -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md

                -- Python
                "black",
                "ruff",
                "ruff-lsp", -- ruff_lsp in lspconfig
                "pylint",
                "pyright",

                -- Lua
                "lua-language-server", -- lua_ls in lspconfig
                "stylua",

                -- JS/TS
                "eslint_d",
                "prettierd",
                "typescript-language-server", -- tsserver in lspconfig
            },
        })

        -- If using mason_lspconfig, uncomment these lines instead:
        -- require("mason-lspconfig").setup({
        --     ensure_installed = {
        --         -- ...
        --     },
        -- })
    end,
}
