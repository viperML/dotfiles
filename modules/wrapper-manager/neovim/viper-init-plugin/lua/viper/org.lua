local orgmode = require("orgmode") -- not lsp but related
orgmode.setup {
  org_startup_folded = "showeverything",
  -- org_agenda_files = {},
  -- org_default_notes_file = '~/Dropbox/org/refile.org',
}
require("org-bullets").setup {
  symbols = {
    checkboxes = {
      done = { "×", "@org.keyword.done" },
      half = { "-", "@org.checkbox.halfchecked" },
      todo = { " ", "@org.keyword.todo" },
    },
  },
}
