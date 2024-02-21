return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>ha", function() require("harpoon.mark").add_file() end, desc = "Mark file with Harpoon" },
    { "<leader>hr", function() require("harpoon.mark").rm_file() end, desc = "Unmark file with Harpoon" },
    { "<leader>hm", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Open Harpoon menu" },
    { "<leader>hn", function() require("harpoon.ui").nav_next() end, desc = "Open Harpoon next file" },
    { "<leader>hp", function() require("harpoon.ui").nav_prev() end, desc = "Open Harpoon previous file" },
    { "<leader>j", function() require("harpoon.ui").nav_file(1) end, desc = "Open Harpoon file 1" },
    { "<leader>k", function() require("harpoon.ui").nav_file(2) end, desc = "Open Harpoon file 2" },
    { "<leader>l", function() require("harpoon.ui").nav_file(3) end, desc = "Open Harpoon file 3" },
    { "<leader>;", function() require("harpoon.ui").nav_file(4) end, desc = "Open Harpoon file 4" },
  },
  config = true
}
