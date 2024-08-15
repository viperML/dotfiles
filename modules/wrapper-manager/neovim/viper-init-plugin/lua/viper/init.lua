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

require("lz.n").load {
  {
    "plenary-nvim",
  },
  -- {
  --   "telescope-fzf-native-nvim",
  --   cmd = "Never",
  -- },
  {
    "telescope-nvim",
    cmd = "Telescope",
    after = function()
      require("telescope").setup {}
      -- require('telescope').load_extension('fzf')
      vim.notify("Telescope loaded")
    end,
  },
}

-- require("lzn-auto-require.loader").register_loader()

vim.notify("viper loaded")
