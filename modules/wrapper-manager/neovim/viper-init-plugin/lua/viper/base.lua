-- First for vim.notify
require("fidget").setup {
  notification = {
    override_vim_notify = true,
    view = {
      stack_upwards = false,
    },
    window = {
      winblend = 0,
      align = "top",
    },
  },
}

vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 0 -- use tabstop

vim.opt.number = true

vim.opt.scrolloff = 2
vim.opt.showmode = false
vim.opt.modeline = true
vim.opt.signcolumn = "yes"

vim.o.timeout = true
vim.o.timeoutlen = 500
