require("viper.base")
require("viper.visual")
require("viper.completion")
require("viper.lsp")
require("viper.tree-sitter")
require("viper.format")
require("viper.org")

require("neovim-project").setup {
  projects = {
    "~/Documents/*",
    "~/Projects/*",
    "~/projects/*",
  },
}

vim.opt.sessionoptions:append("globals")

vim.keymap.set("n", "<leader>p", "<cmd>Telescope neovim-project discover<cr>", { desc = "Project: open" })

require("git-conflict").setup()
vim.keymap.set("n", "<leader>go", "<cmd>GitConflictChooseOurs<cr>", { desc = "Git conflict: select ours" })
vim.keymap.set("n", "<leader>gt", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Git conflict: select theirs" })
