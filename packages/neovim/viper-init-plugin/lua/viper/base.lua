vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 0 -- use tabstop

vim.opt.number = false

vim.opt.scrolloff = 2
vim.opt.showmode = false
vim.opt.modeline = true
vim.opt.signcolumn = "yes:2"

vim.o.timeout = true
vim.o.timeoutlen = 500

vim.o.cmdheight = 0
local messages = {
  "a",
  "o",
  "O",
  "s",
  "t",
  "T",
  "W",
  "I",
  "C",
  "F",
}
local messages_res = ""
for _, m in ipairs(messages) do
  messages_res = messages_res .. m
end
vim.o.shortmess = messages_res

vim.o.showbreak = "↪ "

vim.opt.sessionoptions:remove("folds")

require("viper.lazy").add_specs {

}

-- Ctrl movement
-- vim.opt.keymodel = "startsel,stopsel"
vim.keymap.set({ "n", "v" }, "<C-Right>", "e", { desc = "Jump to next word" })
vim.keymap.set({ "n", "v" }, "<C-Left>", "b", { desc = "Jump to previous word" })
vim.keymap.set("n", "<C-S-Right>", "ve", { desc = "Select to next word" })
vim.keymap.set("n", "<C-S-Left>", "vb", { desc = "Select to previous word" })
vim.keymap.set('i', '<C-BS>', '<C-w>', { desc = 'Delete word backward' })
vim.keymap.set("i", "<C-Del>", "<esc><Right>ce")

-- Inhibit shift+direction
vim.keymap.set({ "n", "i", "v" }, "<S-Up>", "<Up>")
vim.keymap.set({ "n", "i", "v" }, "<S-Down>", "<Down>")
vim.keymap.set({ "n", "i", "v" }, "<C-Up>", "<Up>")
vim.keymap.set({ "n", "i", "v" }, "<C-Down>", "<Down>")


vim.keymap.set({ "n", "v", "i" }, "", "/", { desc = "Search in file" })

vim.opt.ignorecase = true
vim.opt.smartcase = true


vim.opt.splitbelow = true
vim.opt.splitright = true

vim.o.fillchars = "eob:~"
