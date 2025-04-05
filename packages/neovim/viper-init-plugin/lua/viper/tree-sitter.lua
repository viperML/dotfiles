require("viper.lazy").add_specs {
  {
    "nvim-treesitter",
    event = { "BufReadPost", "BufWritePost", "BufNewFile", "DeferredUIEnter" },
    after = function()
      require("viper.lazy").packadd("nvim-treesitter-textobjects")

      ---@dignostic disable: missing-fields
      require("nvim-treesitter.configs").setup {
        -- ignore_install = { "all" },
        highlight = {
          enable = true,
          disable = { "bigfile" },
          -- additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["ia"] = { query = "@parameter.inner", desc = "inner argument" },
              ["aa"] = { query = "@parameter.outer", desc = "around argument" },
            },
          },
        },
      }

      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldlevel = 99

      -- Conflicts with treesitter
      vim.opt.smartindent = false

      -- Don't acidentally run these
      vim.api.nvim_del_user_command("TSUpdate")
      vim.api.nvim_del_user_command("TSUpdateSync")
      vim.api.nvim_del_user_command("TSInstall")
      vim.api.nvim_del_user_command("TSInstallSync")
      vim.api.nvim_del_user_command("TSInstallFromGrammar")
      vim.api.nvim_del_user_command("TSUninstall")

      require("viper.lazy").packadd("nvim-ts-autotag")
      require("nvim-ts-autotag").setup {}

      require("viper.lazy").packadd("nvim-treesitter-context")
      require("treesitter-context").setup {
        enable = true,
        max_lines = 4,
      }
    end,
  },
}
