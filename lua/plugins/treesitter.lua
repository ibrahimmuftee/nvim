return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        -- Playground is integrated into nvim-treesitter itself now
        -- "nvim-treesitter/playground",
    },
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        -- List of parsers to install automatically
        ensure_installed = { "bash", "javascript", "json", "lua", "python", "typescript", "vim", "vimdoc" },
        highlight = {
            enable = true,
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
        indent = {
            -- Syntax-aware indentation with the = operator
            enable = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<leader>vn",
                node_incremental = "n",
                node_decremental = "<S-n>",
                scope_incremental = false,
            },
        },
        textobjects = {
            move = {
                enable = true,

                -- Add jumps to the jumplist for navigating with Ctrl+I/O
                set_jumps = true,
                goto_next_start = {
                    ["]m"] = { query = "@call.outer", desc = "Next method/function call start" },
                    ["]f"] = { query = "@function.outer", desc = "Next function def start" },
                    ["]c"] = { query = "@class.outer", desc = "Next class start" },
                    ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
                    ["]l"] = { query = "@loop.outer", desc = "Next loop start" },

                    -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                    -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                    ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                    ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                },
                goto_next_end = {
                    ["]M"] = { query = "@call.outer", desc = "Next method/function call end" },
                    ["]F"] = { query = "@function.outer", desc = "Next function def end" },
                    ["]C"] = { query = "@class.outer", desc = "Next class end" },
                    ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
                    ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
                },
                goto_previous_start = {
                    ["[m"] = { query = "@call.outer", desc = "Previous method/function call start" },
                    ["[f"] = { query = "@function.outer", desc = "Previous function def start" },
                    ["[c"] = { query = "@class.outer", desc = "Previous class start" },
                    ["[i"] = { query = "@conditional.outer", desc = "Previous conditional start" },
                    ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
                },
                goto_previous_end = {
                    ["[M"] = { query = "@call.outer", desc = "Previous method/function call end" },
                    ["[F"] = { query = "@function.outer", desc = "Previous function def end" },
                    ["[C"] = { query = "@class.outer", desc = "Previous class end" },
                    ["[I"] = { query = "@conditional.outer", desc = "Previous conditional end" },
                    ["[L"] = { query = "@loop.outer", desc = "Previous loop end" },
                },
            },

            select = {
                enable = true,

                -- automatically jump forward to a text object if the
                -- cursor isn't on one when triggering the plugin
                lookahead = true,

                keymaps = {
                    -- Use = as an "assignment" text object
                    ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
                    ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
                    ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
                    ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

                    -- Use "a" for "argument"
                    ["aa"] = { query = "@parameter.outer", desc = "Select outer part of an argument / parameter" },
                    ["ia"] = { query = "@parameter.inner", desc = "Select inner part of an argument / parameter" },

                    -- Use "i" for "conditional" (saving c for class)
                    ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
                    ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

                    -- Use "l" for "loop"
                    ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
                    ["ij"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

                    -- Use "f" for "function definition" (body of a function)
                    ["af"] = { query = "@function.outer", desc = "Select outer part of a function definition" },
                    ["if"] = { query = "@function.inner", desc = "Select inner part of a function definition" },

                    -- Use "m" for "method call" (invocation of a function)
                    ["am"] = { query = "@call.outer", desc = "Select outer part of a method/function call" },
                    ["im"] = { query = "@call.inner", desc = "Select inner part of a method/function call" },

                    -- Use "c" for "class"
                    ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                    ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
                },
            },

            swap = {
                enable = true,
                swap_next = {
                    ["<leader>na"] = "@parameter.inner", -- Swap parameter with next
                    ["<leader>nf"] = "@function.outer", -- Swap function with next
                },
                swap_previous = {
                    ["<leader>pa"] = "@parameter.inner", -- Swap parameter with previous
                    ["<leader>pf"] = "@function.outer", -- Swap function with previous
                },
            },
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

        -- Allow , and ; to repeat motions...
        local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
        vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
        vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_opposite)
        -- ...but make sure they still work for the built-in f/t jumps
        vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
        vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
        vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
        vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
    end,
}
