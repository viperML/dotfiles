vim.opt.ignorecase = true
vim.opt.smartcase = true

require("blink.cmp").setup {
  completion = {
    accept = { auto_brackets = { enabled = true } },
    ghost_text = { enabled = true },
  },
  keymap = {
    preset = "super-tab",
    ["<C-Space>"] = { "show", "fallback" },
  },
}

vim.list_extend(require("viper.lazy.specs"), {
  {
    "nvim-autopairs",
    event = "InsertEnter",
    after = function()
      require("nvim-autopairs").setup {
        disable_filetype = { "scheme", "elisp" },
      }
    end,
  },
})
