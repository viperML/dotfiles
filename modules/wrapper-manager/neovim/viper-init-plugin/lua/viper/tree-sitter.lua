require("nvim-treesitter.configs").setup {
  -- ignore_install = { "all" },
  highlight = {
    enable = true,
    -- disable = {},
    -- additional_vim_regex_highlighting = false,
  },
}

-- vim.wo.foldmethod = "expr"
-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
