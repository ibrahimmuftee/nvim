local opt = vim.opt

-- Begin searching as I type a search string instead of waiting for me to press Enter
opt.incsearch = true

-- Make line numbers default
opt.number = true
opt.relativenumber = true

-- Highlight only the line number for the current line.
-- Disable the second line here to highlight the entire line where the
-- cursor is.
opt.cursorline = true
opt.cursorlineopt = "number"

-- Try to keep this many lines visible above and below the cursor.
-- This makes the window scroll sooner if mashing j / k.
opt.scrolloff = 8

-- -- Synchronize the unnamed / default register with the system clipboard
-- opt.clipboard = "unnamedplus"

-- Don't fold absolutely everything when opening a new file
opt.foldlevelstart = 1

-- Enable mouse mode
opt.mouse = "a"

-- Tab settings
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 0
opt.expandtab = true

-- Automatically set the same indent level on a new line
opt.autoindent = true

-- Increase or decrease indent based on braces or language keywords
opt.smartindent = true

-- Enable break indent
opt.breakindent = true

-- Don't make local backup files. Instead, write undo history to disk.
-- This works especially well with the undotree plugin.
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
opt.ignorecase = true
opt.smartcase = true

-- Decrease update time
opt.updatetime = 250

-- Enable signcolumn (used for diagnostics and gitsigns)
opt.signcolumn = "yes"

-- Colored columns at 72 and 88 are for line lengths, and are based on
-- Python conventions. Docstrings in Python should terminate at 72
-- characters, and 88 is the max line length for the Black formatter.
opt.colorcolumn = { 72, 88 }
-- opt.colorcolumn = "80"

-- Set completeopt to have a better completion experience
opt.completeopt = "menuone,noselect"

