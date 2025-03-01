require("viper.base")
require("viper.visual")
require("viper.lsp")
require("viper.tree-sitter")
require("viper.format")
require("viper.ai")

vim.opt.sessionoptions:append("globals")

vim.keymap.set({ "n", "i", "v" }, "<S-Up>", "<Up>")
vim.keymap.set({ "n", "i", "v" }, "<S-Down>", "<Down>")
vim.keymap.set({ "n", "i", "v" }, "<C-Up>", "<Up>")
vim.keymap.set({ "n", "i", "v" }, "<C-Down>", "<Down>")

require("viper.lazy").finish()

require("viper.health").loaded = true
