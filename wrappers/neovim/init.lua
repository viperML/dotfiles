-- vim.cmd [[colorscheme one]]
-- local current_time = tonumber(os.date "%H%M")
-- if current_time < 1800 and current_time > 500 then
--   colorscheme = "light"
-- else
--   colorscheme = "dark"
-- end

-- vim.opt.background = colorscheme

-- local current_time = tonumber(os.date "%H%M")
-- if current_time < 1800 and current_time > 500 then
--   vim.cmd "colorscheme base16-tomorrow"
-- else
vim.cmd "colorscheme base16-tomorrow-night"
-- end

-- vim.g.mapleader = " "

-- require("nvim_comment").setup {}

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

-- LSP
local cmp = require "cmp"

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
    {name = 'conjure'},
  }, {
    { name = "buffer" },
  }),
}

-- Set configuration for specific filetype.
-- cmp.setup.filetype("gitcommit", {
--   sources = cmp.config.sources({
--     { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = "buffer" },
--   }),
-- })

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline("/", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = "buffer" },
--   },
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig")["rnix"].setup {
  capabilities = capabilities,
  autostart = true,
  cmd = { "nil" },
}

require("nvim-treesitter.configs").setup {
  -- ignore_install = { "all" },
  highlight = {
    enable = true,
    -- disable = {},
    -- additional_vim_regex_highlighting = false,
  },
}

require("hlargs").setup()

require("ibl").setup()

-- let g:conjure#filetype#scheme = "conjure.client.guile.socket"
vim.g['conjure#filetype#scheme'] = "conjure.client.guile.socket"
vim.g["conjure#client#guile#socket#pipename"] = ".guile-socket"


-- require("neo-tree").setup({
-- })

vim.o.timeout = true
vim.o.timeoutlen = 500

local wk = require("which-key")
wk.setup()

wk.register({
    ["<leader>b"] = { "<cmd>Neotree toggle<cr>", "Open Neotree" },
})

