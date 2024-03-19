return {
    {
        "neovim/nvim-lspconfig",
        cond = not vim.g.vscode,
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- Make sure cmp is installed and configured somewhere, as without it,
            -- this plugin will fail
            "hrsh7th/cmp-nvim-lsp",

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { "j-hui/fidget.nvim", tag = "legacy", opts = {} },
        },
        opts = {
            -- This table is my convention, not from nvim-lspconfig.
            -- I iterate through the top-level keys of this table to
            -- determine which servers to configure. The value attached
            -- to each top-level key is a table with the settings for
            -- that language server.
            servers = {
                -- Python
                pyright = {
                    pyright = {
                        -- Use Ruff to organize imports, not Pyright
                        disableOrganizeImports = true,
                        capabilities = {
                            textDocument = {
                                publishDiagnostics = {
                                    tagSupport = {
                                        -- Disable diagnostics from this language server
                                        --
                                        -- In theory, "1" means "clients are allowed to render this, but they
                                        -- should appear greyed out or disabled instead of with an error
                                        -- squiggle." However, Neovim doesn't seem to respect this, so values
                                        -- of 1 and 2 are interchangeable.
                                        --
                                        -- References:
                                        -- https://github.com/neovim/nvim-lspconfig/issues/726#issuecomment-1439132189
                                        -- https://github.com/microsoft/pyright/discussions/5852
                                        -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#diagnosticTag
                                        valueSet = { 2 },
                                    },
                                },
                            },
                        },
                    },
                    python = {
                        -- analysis = {
                        --     -- "off", "basic", "strict" (default: "basic")
                        --     -- Better to set this per-project in pyproject.toml
                        --     -- https://github.com/microsoft/pyright/blob/main/docs/settings.md
                        --     typeCheckingMode = "strict",
                        -- },
                    },
                },
                ruff_lsp = {},
                tsserver = {},

                -- Lua
                lua_ls = {
                    Lua = {
                        -- Allow the LSP to recognize the "vim" global
                        diagnostics = {
                            globals = { "vim" },
                        },
                        -- Formatter supports .editorconfig files. Details here:
                        -- https://github.com/LuaLS/lua-language-server/wiki/Formatter
                        format = { enable = true },

                        -- No thank you
                        telemetry = { enable = false },

                        -- Ensure the language server knows about Vim's runtime
                        -- config files
                        workspace = {
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.stdpath("config") .. "/lua"] = true,
                            },
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            local lspconfig = require("lspconfig")

            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            -- Add some style to the LSP popup windows. See
            -- :h nvim_open_win for the available options
            local ui_handlers = {
                ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                    border = "single",
                }),
                ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                    border = "double",
                }),
            }

            for server_name, server_config in pairs(opts.servers) do
                -- I don't need an on_attach function because my custom
                -- LSP keymaps are handled with an autocmd in my
                -- main keymaps file.
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                    settings = server_config,
                    handlers = ui_handlers,
                })
            end
        end,
    },
}
