-- vim.cmd("colorscheme base16-tomorrow-night")
--
-- vim.g.transparent_enabled = true
-- require("transparent").setup {}

vim.opt.termguicolors = true
require("bufferline").setup {
  options = {
    always_show_bufferline = false,
    right_mouse_command = nil,
    middle_mouse_command = "bdelete! %d",
    indicator = {
      style = " ",
    },
  },
}

require("lualine").setup {
  options = {
    theme = "codedark",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
}

require("neo-tree").setup {
  close_if_last_window = true,
  filesystem = {
    group_empty_dirs = true,
    use_libuv_file_watcher = true,
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        "node_modules",
        ".git",
      },
    },
  },
}
vim.keymap.set("n", "<leader>b", "<cmd>Neotree show toggle<cr>", { desc = "Neotree toggle" })

local gitsigns = require("gitsigns")
gitsigns.setup()

vim.keymap.set("n", "<leader>ga", gitsigns.stage_hunk, { desc = "Git: stage hunk" })
vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Git: preview hunk" })
vim.keymap.set("n", "<leader>gb", function()
  gitsigns.blame_line { full = true }
end, { desc = "Git: blame line" })

-- require("minintro").setup {
--   color = "#4d4d4d",
-- }

require("telescope").setup {}

vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "Telescope: find files" })

local wk = require("which-key")
wk.setup {
  icons = {
    mappings = false,
  },
}
