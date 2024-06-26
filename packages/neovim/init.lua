vim.cmd("colorscheme base16-tomorrow-night")

vim.opt.termguicolors = true
require("bufferline").setup {
  options = {
    right_mouse_command = nil,
    middle_mouse_command = "bdelete! %d",
    indicator = {
      style = " ",
    },
  },
}

require("gitsigns").setup {}
vim.opt.list = true

require("lualine").setup {
  options = {
    theme = "base16",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
}

-- Autopairs
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
    -- ["<C-Space>"] = cmp.mapping.complete(),
    -- ["<C-e>"] = cmp.mapping.abort(),
    -- ["<CR>"] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
    { name = "conjure" },
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
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local nvim_lsp = require("lspconfig")

nvim_lsp.rnix.setup {
  capabilities = capabilities,
  autostart = true,
  cmd = { "nil" },
}

local on_attach = function(client)
  require("completion").on_attach(client)
end

nvim_lsp.rust_analyzer.setup {
  on_attach = on_attach,
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
  on_attach = on_attach,
  root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
}

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  root_dir = nvim_lsp.util.root_pattern("package.json"),
  single_file_support = false,
}

nvim_lsp.clangd.setup {}

nvim_lsp.ltex.setup {
  filetypes = { "markdown", "org", "tex" },
}

nvim_lsp.astro.setup {}

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

-- Rest

require("hlargs").setup()

require("ibl").setup()

vim.g["conjure#filetype#scheme"] = "conjure.client.guile.socket"
vim.g["conjure#client#guile#socket#pipename"] = ".guile-socket"
vim.g["conjure#filetypes"] = { "scheme", "fennel", "clojure" }

vim.o.timeout = true
vim.o.timeoutlen = 500

local wk = require("which-key")
wk.setup()

wk.register {
  ["<leader>b"] = { "<cmd>Neotree show toggle<cr>", "Open Neotree" },
  ["<leader>."] = { vim.lsp.buf.hover, "LSP hover" },
}

orgmode.setup {
  -- org_agenda_files = {},
  -- org_default_notes_file = '~/Dropbox/org/refile.org',
}

require("org-bullets").setup()

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
  vim.api.nvim_command("Neotree show")
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
