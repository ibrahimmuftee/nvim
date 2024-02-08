return {
    "mhartington/formatter.nvim",
    cmd = { "Format", "FormatLock", "FormatWrite", "FormatWriteLock" },
    keys = {
        {
            "<leader>rf",
            function()
                vim.cmd([[FormatLock]])
            end,
            desc = "[R]e[f]ormat current buffer",
        },
    },
    config = function()
        require("formatter").setup({
            filetype = {
                javascript = {
                    -- npm install -g @fsouza/prettierd
                    require("formatter.filetypes.javascript").prettierd,
                },
                json = {
                    -- npm install -g @fsouza/prettierd
                    require("formatter.filetypes.json").prettierd,
                },
                lua = {
                    -- Install binaries from here:
                    -- https://github.com/JohnnyMorganz/StyLua
                    require("formatter.filetypes.lua").stylua,
                },
                markdown = {
                    -- npm install -g @fsouza/prettierd
                    require("formatter.filetypes.markdown").prettierd,
                },
                python = {
                    -- pipx install black
                    require("formatter.filetypes.python").black,
                },
                typescript = {
                    -- npm install -g @fsouza/prettierd
                    require("formatter.filetypes.typescript").prettierd,
                },
                yaml = {
                    -- npm install -g @fsouza/prettierd
                    require("formatter.filetypes.yaml").prettierd,
                },
            },
        })
    end,
}
