return {
    -- Rich terminal
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = {
        "ToggleTerm",
    },
    cond = not vim.g.vscode,
    keys = {
        { "<A-g>", nil, { "n", "t" } },
        { "<A-t>", nil, { "n", "t" } },
    },
    config = function()
        local toggleterm = require("toggleterm")
        local Terminal = require("toggleterm.terminal").Terminal

        local shell = Terminal:new({
            cmd = "pwsh -NoLogo -NoProfile",
            direction = "vertical",
            env = {
                -- Opt out of PowerShell update checking for this terminal
                -- https://github.com/PowerShell/PowerShell/issues/16234
                POWERSHELL_UPDATECHECK = "Off",
                POWERSHELL_UPDATECHECK_OPTOUT = "1",
            },
            on_open = function(term)
                local opts = { buffer = 0 }
                -- Toggle out of terminal mode and into normal mode
                vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)

                -- Move focus to the left split, usually the editor
                -- vim.keymap.set("t", "<esc>", [[<C-\><C-n><C-w>h]], opts)
            end,
        })
        local toggle_shell = function()
            shell:toggle()
        end

        local lazygit = Terminal:new({
            cmd = "lazygit",
            direction = "float",
            float_opts = {
                border = "double",
            },
            hidden = true,
            on_open = function(_)
                -- Always enter insert / terminal mode when opening the terminal.
                -- Without this, sometimes the terminal will open, but you'll stay
                -- in Normal mode, which can't interact with a terminal.
                vim.cmd("startinsert!")
            end,
        })

        local toggle_lazygit = function()
            lazygit:toggle()
        end

        toggleterm.setup({
            size = function(term)
                if term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
                return 20
            end,
            terminal_mappings = false,
        })

        vim.keymap.set({ "n", "t" }, "<A-g>", function()
            toggle_lazygit()
        end, { noremap = true, silent = true, desc = "Toggle LazyGit" })
        vim.keymap.set({ "n", "t" }, "<A-t>", function()
            toggle_shell()
        end, { noremap = true, silent = true, desc = "Toggle terminal" })
    end,
}
