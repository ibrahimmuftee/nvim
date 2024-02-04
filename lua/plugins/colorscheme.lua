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
  opts = {
    options = {
      transparent_bg = true;
    },
  },
  config = function(_, opts)
    vim.opt.termguicolors = true
    vim.opt.background = "dark"

    vim.cmd.colorscheme("gruvbox")
  end,

}
