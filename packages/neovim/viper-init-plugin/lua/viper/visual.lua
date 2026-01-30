vim.opt.termguicolors = true

require('mini.icons').setup()

require("gruvbox").setup {
  transparent_mode = true,
}

vim.cmd([[ colorscheme gruvbox ]])

require("viper.lazy").add_specs {
  {
    "which-key.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("which-key").setup {
        icons = {
          mappings = false,
        },
      }
    end,
  },
}
