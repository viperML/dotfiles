vim.list_extend(require("viper.lazy.specs"), {
  {
    "orgmode",
    ft = { "org" },
    after = function()
      require("orgmode").setup {
        org_startup_folded = "showeverything",
        -- org_agenda_files = {},
        -- org_default_notes_file = '~/Dropbox/org/refile.org',
      }

      require("viper.lazy").packadd("org-bullets.nvim")
      require("org-bullets").setup {
        symbols = {
          checkboxes = {
            done = { "×", "@org.keyword.done" },
            half = { "-", "@org.checkbox.halfchecked" },
            todo = { " ", "@org.keyword.todo" },
          },
        },
      }
    end,
  },
})
