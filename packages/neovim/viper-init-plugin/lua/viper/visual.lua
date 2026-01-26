vim.opt.termguicolors = true

require('mini.icons').setup()

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
