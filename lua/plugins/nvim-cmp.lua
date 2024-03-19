return {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    cond = not vim.g.vscode,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        "L3MON4D3/LuaSnip", -- Snippet engine
        "rafamadriz/friendly-snippets", -- Useful snippets in VSCode snippet format
        "onsails/lspkind.nvim", -- Pretty formatting in the completion menu

        -- Completion sources
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",

        -- GitHub Copilot
        "zbirenbaum/copilot.lua",
        "zbirenbaum/copilot-cmp",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        -- Load any VSCode-style snippets from other installed plugins
        require("luasnip.loaders.from_vscode").lazy_load()

        -- Init Copilot
        require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
        })
        require("copilot_cmp").setup()

        cmp.setup({
            completion = {
                -- See :help completeopt
                completeopt = "menu,menuone,noinsert,preview",
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),

                -- Ctrl+Space does not currently work in Neovim core on Windows
                -- https://github.com/neovim/neovim/issues/8435
                -- ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-c>"] = cmp.mapping.complete(),

                ["<C-e>"] = cmp.mapping.abort(),
                ["<C-y>"] = cmp.mapping.confirm({
                    -- Accept currently selected item
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
                }),
                ["<C-S-y>"] = cmp.mapping.confirm({
                    -- Accept currently selected item, replacing stuff as needed
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }),
                ["<CR>"] = cmp.mapping({
                    -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#safely-select-entries-with-cr
                    i = function(fallback)
                        -- In insert mode, only use Enter to complete something if cmp
                        -- is active and the user has explicitly selected an item
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end,
                    s = cmp.mapping.confirm({ select = true }),
                    c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                }),
            }),
            sources = {
                { name = "nvim_lsp_signature_help", group_index = 1 },
                { name = "nvim_lsp", group_index = 1 },
                { name = "luasnip", group_index = 1 },
                { name = "copilot", group_index = 2 },
                { name = "path", group_index = 2 },
                { name = "buffer", group_index = 2, keyword_length = 5 },
            },
            -- sources = cmp.config.sources({
            --     { name = "nvim_lsp_signature_help" },
            --     { name = "nvim_lsp" },
            --     { name = "luasnip" },
            -- }, {
            --     { name = "path" },
            --     { name = "buffer", keyword_length = 5 },
            -- }),
            formatting = {
                format = require("lspkind").cmp_format({
                    mode = "symbol_text",
                    -- maxwidth = 50,
                    maxwidth = function()
                        return math.floor(0.45 * vim.o.columns)
                    end,
                    ellipsis_char = "...",
                    show_labelDetails = true,
                    symbol_map = { Copilot = " " },
                }),
            },
            experimental = {
                ghost_text = {
                    hl_group = "LspCodeLens",
                },
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
        })
    end,
}
