local function tele_builtin(name, opts)
    return function()
        require("telescope.builtin")[name](opts)
    end
end

local function project_files()
    -- Use the git_files picker when possible, but fall back to the find_files picker
    -- if not working inside a Git repo
    -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#falling-back-to-find_files-if-git_files-cant-find-a-git-directory
    local opts = {}
    local cwd = vim.fn.getcwd()
    if directories_in_work_trees[cwd] == nil then
        vim.fn.system("git rev-parse --is-inside-work-tree")
        directories_in_work_trees[cwd] = vim.v.shell_error == 0
    end
    if directories_in_work_trees[cwd] then
        require("telescope.builtin").git_files(opts)
    else
        require("telescope.builtin").find_files(opts)
    end
end

return {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
        },
        "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
        { "<C-p>", tele_builtin("find_files"), desc = "Find files" },
        -- { "<C-p>", project_files, desc = "Find files" },
        { "<leader>/", tele_builtin("live_grep"), desc = "Find text in files (grep)" },
        { "<leader>,", tele_builtin("buffers"), desc = "File buffers" },
        { "<leader>sd", tele_builtin("diagnostics"), desc = "[S]earch [d]iagnostics" },
        { "<leader>sh", tele_builtin("help_tags"), desc = "[S]earch [h]elp tags" },
        { "<leader>sm", tele_builtin("marks"), desc = "[S]earch [m]arks" },
        { "<leader>sr", tele_builtin("resume"), desc = "[S]earch [r]esume previous" },

    },
    opts = function()
        local telescopeConfig = require("telescope.config")

        -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
        -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#ripgrep-remove-indentation

        -- Clone the default Telescope configuration
        local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

        -- I want to search in hidden/dot files.
        table.insert(vimgrep_arguments, "--hidden")
        -- I don't want to search in the `.git` directory.
        table.insert(vimgrep_arguments, "--glob")
        table.insert(vimgrep_arguments, "!**/.git/*")
        -- I want to trim leading whitespace
        table.insert(vimgrep_arguments, "--trim")

        return {
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                vimgrep_arguments = vimgrep_arguments,
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                ["ui-select"] = {
                    require("telescope.themes").get_cursor(),
                },
            },
            pickers = {
                find_files = {
                    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                    find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
                },
            },
        }
    end,
    config = function(_, opts)
        require("telescope").setup(opts)
        -- require("telescope").load_extension("fzf")
        require("telescope").load_extension("ui-select")
    end,
}
