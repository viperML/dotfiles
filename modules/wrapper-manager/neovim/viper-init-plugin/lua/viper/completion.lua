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
