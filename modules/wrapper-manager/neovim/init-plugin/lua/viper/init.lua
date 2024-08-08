vim.cmd("colorscheme base16-tomorrow-night")

vim.g.transparent_enabled = true
require("transparent").setup {}

vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 0 -- use tabstop

vim.opt.number = true

vim.opt.scrolloff = 2
vim.opt.showmode = false
vim.opt.modeline = true
vim.opt.signcolumn = "yes"

vim.opt.termguicolors = true
require("bufferline").setup {
  options = {
    always_show_bufferline = false,
    right_mouse_command = nil,
    middle_mouse_command = "bdelete! %d",
    indicator = {
      style = " ",
    },
  },
}

-- require("gitsigns").setup {}
-- vim.opt.list = true

require("lualine").setup {
  options = {
    theme = "base16",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
}

local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
npairs.setup {
  check_ts = true,
  -- ts_config = {
  -- }
  enable_check_bracket_line = false,
  -- disable_filetype = { "scheme" },
}

local lisps = {
  "scheme",
  "racket",
  "clojure",
}
npairs.get_rules("'")[1].not_filetypes = lisps
npairs.get_rules("`")[1].not_filetypes = lisps
npairs.get_rules("(")[1].not_filetypes = lisps
npairs.get_rules("[")[1].not_filetypes = lisps
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

-- Completion
local cmp = require("cmp")
cmp.setup {
  -- snippet = {
  --   -- REQUIRED - you must specify a snippet engine
  --   expand = function(args)
  --     vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
  --     -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
  --     -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
  --     -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  --   end,
  -- },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert {
    -- ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
        return
      end
      fallback()
    end, { "i", "c" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
        return
      end
      fallback()
    end, { "i", "c" }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "treesitter" },
    { name = "path", option = { trailing_slash = true } },
    { name = "buffer" },
    -- { name = "vsnip" }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
    { name = "orgmode" },
    -- { name = "conjure" },
  }, {
    { name = "buffer" },
  }),
}

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- LSP
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local nvim_lsp = require("lspconfig")

vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "LSP hover" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP action" })

nvim_lsp.rnix.setup {
  capabilities = capabilities,
  cmd = { "nil" },
}

-- local on_attach = function(client)
--   require("completion").on_attach(client)
-- end

nvim_lsp.rust_analyzer.setup {
  -- on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
      },
    },
  },
}

vim.g.markdown_fenced_languages = {
  "ts=typescript",
}

nvim_lsp.denols.setup {
  -- on_attach = on_attach,
  root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
}

nvim_lsp.tsserver.setup {
  -- on_attach = on_attach,
  root_dir = nvim_lsp.util.root_pattern("package.json"),
  single_file_support = false,
}

nvim_lsp.clangd.setup {}

nvim_lsp.ltex.setup {
  filetypes = {
    "markdown",
    -- "org",
    "tex",
  },
}

nvim_lsp.astro.setup {}

nvim_lsp.mesonlsp.setup {}

nvim_lsp.bashls.setup {}

-- Treesitter
local orgmode = require("orgmode")

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

-- Rest

-- require("hlargs").setup()

-- require("ibl").setup()

vim.g["conjure#filetype#scheme"] = "conjure.client.guile.socket"
vim.g["conjure#client#guile#socket#pipename"] = ".guile-socket"
vim.g["conjure#filetypes"] = { "scheme", "fennel", "clojure" }

vim.o.timeout = true
vim.o.timeoutlen = 500

vim.keymap.set("n", "<leader>b", "<cmd>Neotree show toggle<cr>", { desc = "Neotree toggle" })

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

require("Comment").setup()

vim.filetype.add {
  filename = {
    [".envrc"] = "bash",
  },
}

require("neo-tree").setup {
  close_if_last_window = true,
  filesystem = {
    group_empty_dirs = true,
    use_libuv_file_watcher = true,
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        "node_modules",
        ".git",
      },
    },
  },
}

local function when_empty()
  -- vim.api.nvim_command("Neotree show")
end

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  pattern = { "*" },
  callback = function()
    -- Get the current buffer content
    -- local buffer_content = vim.api.nvim_buf_get_lines(0, 1, -1, false)

    -- -- Check if the buffer is empty
    -- if #buffer_content == 0 then
    --   if_empty()
    --   return
    -- end

    local filename = vim.api.nvim_buf_get_name(0)

    if vim.fn.filereadable(filename) == 0 then
      when_empty()
      return
    end
  end,
})

require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "alejandra" },
    c = { "clang-format" },
    typst = { "typstyle" },
    rust = { "rustfmt" },
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

require("telescope").setup {}

vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "Telescope: find files" })

local wk = require("which-key")
wk.setup({
  icons = {
    mappings = false,
  },
})

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

require("minintro").setup({
  color = "#4d4d4d",
})

-- require('session_manager').setup({})

require("neovim-project").setup({
    projects = {
      "~/Documents/*",
      "~/Projects/*",
      "~/projects/*",
    },
})

vim.opt.sessionoptions:append("globals")
