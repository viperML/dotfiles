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

vim.opt.sessionoptions:append("globals")
-- require("neovim-project").setup {
--   -- manual_mode = true,
--   projects = {
--     "~/Documents/*",
--     "~/Projects/*",
--     "~/projects/*",
--   },
-- }

-- FIXME
-- vim.keymap.set("n", "<leader>p", "<cmd>Telescope neovim-project discover<cr>", { desc = "Project: open" })

local specs = {
  {
    "viper-lazy-plugin",
  },
  -- {
  --   "telescope-fzf-native-nvim",
  --   cmd = "Never",
  -- },
  -- {
  --   "telescope-nvim",
  --   cmd = "Telescope",
  --   before = function()
  --     require('lz.n').trigger_load("plenary-nvim")
  --     require("lz.n").trigger_load("telescope-fzf-native-nvim")
  --   end,
  --   after = function()
  --     require("telescope").setup {}
  --     require('telescope').load_extension('fzf')
  --     vim.notify("Telescope loaded")
  --   end,
  -- },
}

for _, module in ipairs({
  "viper.base",
  "viper.visual",
  "viper.completion",
}) do
  vim.list_extend(specs, require(module))
end

require("lz.n").load(specs)

vim.notify("viper loaded")
