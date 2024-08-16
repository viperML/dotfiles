vim.notify("loading viper.completion")

return {
  {
    "git-conflict.nvim",
    after = function()
      require("git-conflict").setup()
      vim.keymap.set("n", "<leader>g<Up>", "<cmd>GitConflictChooseOurs<cr>", { desc = "Git conflict: select ours" })
      vim.keymap.set("n", "<leader>g<Down>", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Git conflict: select theirs" })
      vim.keymap.set("n", "<leader>g<Right>", "<cmd>GitConflictChooseBoth<cr>", { desc = "Git conflict: select both" })
    end
  },
  {
    "neovim-session-manager",
    after = function()
      local config = require('session_manager.config')
      require("session_manager").setup {
        autoload_mode = config.AutoloadMode.Disabled,
      }
    end
  }
}
