local two_tabs_default = {
  "astro",
  -- "c",
  -- "cpp",
  "css",
  "gitconfig",
  "html",
  "javascript",
  "json",
  "jsonc",
  "lua",
  "markdown",
  "mdx",
  "meson",
  "nix",
  "r",
  "scheme",
  "terraform",
  "typescript",
  "typst",
}

for _, lang in ipairs(two_tabs_default) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = lang,
    callback = function()
      vim.opt_local.tabstop = 2
    end,
  })
end

local cc = {
  ["rust"] = 100,
  ["scheme"] = 100,
  ["lua"] = 100,

  ["python"] = 80,
}

for lang, col in pairs(cc) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = lang,
    callback = function()
      vim.opt_local.colorcolumn = "" .. col
    end,
  })
end

local cc_wrap = {
  -- ["markdown"] = 80,
  -- ["mdx"] = 80,
  -- ["typst"] = 80,
}

for lang, col in pairs(cc_wrap) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = lang,
    callback = function()
      vim.opt_local.colorcolumn = "" .. col
      vim.opt_local.textwidth = col
    end,
  })
end

vim.list_extend(require("viper.lazy.specs"), {
  {
    "indent-blankline.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("ibl").setup()
    end,
  },
  {
    "conform.nvim",
    cmd = "Format",
    keys = { "gq" },
    after = function()
      require("conform").setup {
        formatters = {
          guix = {
            command = "guix",
            args = { "style", "-f", "$FILENAME" },
            stdin = false,
          },
        },
        formatters_by_ft = {
          lua = { "stylua" },
          nix = { "nixfmt" },
          c = { "clang-format" },
          typst = { "typstyle" },
          rust = { "rustfmt" },
          haskell = { "fourmolu" },
          scheme = { "guix" },
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
    end,
  },
  {
    "parinfer-rust",
    ft = { "scheme", "lisp", "elisp" },
  },
  {
    "comment.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("Comment").setup {}
    end,
  },
})
