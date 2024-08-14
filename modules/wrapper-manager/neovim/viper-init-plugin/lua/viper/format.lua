require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "alejandra" },
    c = { "clang-format" },
    typst = { "typstyle" },
    rust = { "rustfmt" },
    haskell = { "fourmolu" },
  },
}

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format { async = true, lsp_format = "fallback", range = range }
end, { range = true })

local paredit = require("nvim-paredit")
local paredit_scheme = require("nvim-paredit-scheme")

paredit_scheme.setup(paredit)

paredit.setup {
  filetypes = { "scheme" },
}

require("guess-indent").setup {}

local two_tabs_default = {
  "scheme",
  "lua",
  "nix",
  "json",
  "javascript",
  "typescript",
  "css",
  "html",
  "jsonc",
  "astro",
  "c",
  "cpp",
  "meson",
  "markdown",
  "r",
}

for _, lang in ipairs(two_tabs_default) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = lang,
    callback = function()
      vim.opt_local.tabstop = 2
    end,
  })
end

require("ibl").setup()

require("Comment").setup()
