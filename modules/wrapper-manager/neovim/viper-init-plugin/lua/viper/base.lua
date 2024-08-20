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

vim.opt.sessionoptions:remove("folds")

vim.opt.shortmess = "I" -- disable intro message


vim.list_extend(require("viper.lazy.specs"), {
  {
    "vim-nix",
    ft = {"nix"},
  },
  {
    "neovim-session-manager",
    -- event = "DeferredUIEnter",
    cmd = "SessionManager",
    keys = {"<leader>p"},
    after = function()
      local session_config = require('session_manager.config')
      require('session_manager').setup({
          autoload_mode = session_config.AutoloadMode.Disabled,
      })

      vim.keymap.set("n", "<leader>p", require("session_manager").load_session, { desc = "Project: open" })
    end
  },
})

