vim.list_extend(require("viper.lazy.specs"), {
  {
    "nvim-treesitter",
    event = "DeferredUIEnter",
    after = function()
      require("nvim-treesitter.configs").setup {
        -- ignore_install = { "all" },
        highlight = {
          enable = true,
          -- disable = {},
          -- additional_vim_regex_highlighting = false,
        },
      }

      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldlevel = 99

      -- Don't acidentally run these
      vim.api.nvim_del_user_command("TSUpdate")
      vim.api.nvim_del_user_command("TSUpdateSync")
      vim.api.nvim_del_user_command("TSInstall")
      vim.api.nvim_del_user_command("TSInstallSync")
      vim.api.nvim_del_user_command("TSInstallFromGrammar")
      vim.api.nvim_del_user_command("TSUninstall")
    end,
  },
})
