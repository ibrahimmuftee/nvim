-- return {
--
--   "Mofiqul/dracula.nvim",
--   opts = {
--     options = {
--       transparent_bg = true;
--     },
--   },
--   config = function(_, opts)
--     vim.opt.termguicolors = true
--     vim.opt.background = "dark"
--
--     vim.cmd.colorscheme("dracula")
--   end,
--
-- }

return {

  "ellisonleao/gruvbox.nvim",
  -- opts = {
  --   options = {
  --     transparent_mode = true,
  --   },
  -- },
  -- config = function()
  --   vim.opt.termguicolors = true
  --   vim.opt.background = "dark"
  --
  --   vim.cmd.colorscheme("gruvbox")
  -- end,
  init = function()
    require("gruvbox").setup({
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = false,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })

    vim.opt.termguicolors = true
    vim.opt.background = "dark"

    vim.cmd.colorscheme("gruvbox")
  end,
}
