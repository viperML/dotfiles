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
