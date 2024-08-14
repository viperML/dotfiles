require("viper.base")
require("viper.visual")
require("viper.completion")
require("viper.lsp")
require("viper.dap")
require("viper.tree-sitter")
require("viper.format")
require("viper.org")
require("viper.direnv")

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
vim.keymap.set("n", "<leader>g<Up>", "<cmd>GitConflictChooseOurs<cr>", { desc = "Git conflict: select ours" })
vim.keymap.set("n", "<leader>g<Down>", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Git conflict: select theirs" })
vim.keymap.set("n", "<leader>g<Right>", "<cmd>GitConflictChooseBoth<cr>", { desc = "Git conflict: select both" })

vim.keymap.set({ "n", "i", "v" }, "<S-Up>", "<Up>")
vim.keymap.set({ "n", "i", "v" }, "<S-Down>", "<Down>")
vim.keymap.set({ "n", "i", "v" }, "<C-Up>", "<Up>")
vim.keymap.set({ "n", "i", "v" }, "<C-Down>", "<Down>")
