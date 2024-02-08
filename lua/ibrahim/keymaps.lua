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

require("ibrahim.lsp").add_on_attach(function(_, bufnr)
    -- Default / basic LSP keymaps
    -- These are only added to the current buffer when an LSP client is
    -- attached
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, remap = false })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    -- Navigation
    -- Some of these get overridden by Telescope later
    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gt", vim.lsp.buf.type_definition, "[G]oto [t]ype Definition")
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>sd", vim.lsp.buf.document_symbol, "[S]earch [D]ocument symbol names")
    nmap("<leader>sn", vim.lsp.buf.workspace_symbol, "[S]earch [D]ocument symbol names")

    -- Diagnostics
    nmap("<leader>ds", vim.diagnostic.open_float, "[s]how [d]iagnostic window")
    nmap("<leader>dn", function()
        vim.diagnostic.goto_next({ float = true })
    end, "Go to [n]ext [d]iagnostic")
    nmap("<leader>dp", function()
        vim.diagnostic.goto_prev({ float = true })
    end, "Go to [p]revious [d]iagnostic")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    -- nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Workspace
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")
end)
