vim.g.mapleader = " "

local function map(mode, left, right, opts)
    local default_opts = {
        noremap = true,
        silent = true,
    }
    opts = opts or {}
    -- "keep" mode preserves the values from the leftmost table,
    -- so prioritize any options provided over the defaults
    local full_opts = vim.tbl_extend("keep", opts, default_opts)
    vim.keymap.set(mode, left, right, full_opts)
end

-- Clear any highlighted searches when pressing Esc
-- This lets me leave hlsearch on by default while having an easy way to clear
-- it again.
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- In visual mode, use J and K (shifted) to move lines around
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor in the same place when using J to join lines
map("n", "J", "mzJ`z")

-- Center the screen when jumping around with C-d and C-u
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Center the screen when jumping to next / previous search terms
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Quick maps to paste/delete without overwriting the current buffer
map("x", "<leader>p", '"_dP')
map({ "n", "v" }, "<leader>d", '"_dP')

-- Easier split navigation
-- map("n", "<C-h>", "<C-w>h")
-- map("n", "<C-j>", "<C-w>j")
-- map("n", "<C-k>", "<C-w>k")
-- map("n", "<C-l>", "<C-w>l")

-- Using tmux to split navigate
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>")
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>")
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>")
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>")

-- I always confuse G and gg.
-- With this mapping, G goes to the bottom of the buffer as usual - unless the
-- cursor is already at the bottom, in which case, it jumps to the top instead.
-- Credit to this Reddit user:
-- https://www.reddit.com/r/vim/comments/suwigu/im_not_the_only_person_who_switches_up_gg_and/hxcr3yo/
map("n", "G", "line('.') == line('$') ? 'gg' : 'G'", { noremap = true, expr = true })

-- Always use n to search forward in the buffer and N to search backwards,
-- even if the search was invoked with ? (which usually reverses the two)
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- System clipboard
map({ "n", "v" }, "<leader>cd", '"+d', { desc = "Clipboard delete" })
map({ "n", "v" }, "<leader>cp", '"+p', { desc = "Clipboard paste" })
map({ "n", "v" }, "<leader>cy", '"+y', { desc = "Clipboard yank" })

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("JoshuaLspConfig", {}),
    callback = function(evt)
        local function lsp_map(mode, lhs, rhs, desc)
            local opts = { buffer = evt.buf, desc = "LSP: " .. (desc or "") }
            map(mode, lhs, rhs, opts)
        end

        local has_telescope, _ = pcall(require, "telescope")
        local function lsp_telescope_map(mode, lhs, with_telescope_rhs, no_telescope_rhs, desc)
            if has_telescope then
                desc = desc .. " (Telescope)"
                lsp_map(mode, lhs, with_telescope_rhs, desc)
            else
                lsp_map(mode, lhs, no_telescope_rhs, desc)
            end
        end
        local function tele_builtin(name, opts)
            return function()
                require("telescope.builtin")[name](opts)
            end
        end

        -- Navigation
        -- Some of these get overridden by Telescope later
        lsp_map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        lsp_map("n", "gt", vim.lsp.buf.type_definition, "[G]oto [t]ype Definition")
        lsp_map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        -- lsp_map("n", "gr", vim.lsp.buf.references, "[G]oto [R]eferences")
        lsp_map("n", "gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        lsp_map("n", "<leader>sd", vim.lsp.buf.document_symbol, "[S]earch [D]ocument symbol names")
        lsp_map("n", "<leader>sn", vim.lsp.buf.workspace_symbol, "[S]earch [D]ocument symbol names")

        lsp_telescope_map("n", "gr", tele_builtin("lsp_references"), vim.lsp.buf.references, "Go to references")
        lsp_telescope_map(
            "n",
            "<leader>sd",
            tele_builtin("lsp_document_symbols"),
            vim.lsp.buf.document_symbol,
            "Search document symbols"
        )
        lsp_telescope_map(
            "n",
            "<leader>sn",
            tele_builtin("lsp_dynamic_workspace_symbols"),
            vim.lsp.buf.workspace_symbol,
            "Search workspace symbols"
        )

        -- Code changes
        lsp_map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
        lsp_map("n", "<leader>ca", vim.lsp.buf.code_action, "Code actions")

        -- Diagnostics
        lsp_map("n", "<leader>ds", vim.diagnostic.open_float, "[s]how [d]iagnostic window")
        lsp_map("n", "<leader>dn", function()
            vim.diagnostic.goto_next({ float = true })
        end, "Go to [n]ext [d]iagnostic")
        lsp_map("n", "<leader>dp", function()
            vim.diagnostic.goto_prev({ float = true })
        end, "Go to [p]revious [d]iagnostic")

        -- See `:help K` for why this keymap
        lsp_map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
        lsp_map("n", "<C-S-k>", vim.lsp.buf.signature_help, "Signature Documentation")

        -- Workspace
        lsp_map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
        lsp_map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
        lsp_map("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist Folders")
    end,
})
