local npairs = require("nvim-autopairs")
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

local cmp = require("cmp")

cmp.setup {
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  experimental = {
    ghost_text = true,
  },
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
    ["<CR>"] = cmp.mapping.confirm { select = false }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Right>"] = cmp.mapping.confirm { select = false },
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Tab>"] = cmp.mapping(function(fallback)
      -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
        if not entry then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
        end
        cmp.confirm()
      else
        fallback()
      end
    end, { "i", "s", "c" }),
    -- ["<Down>"] = cmp.mapping(function(callback)
    --   if cmp.visible() then
    --     cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    --   else
    --     fallback()
    --   end
    -- end, {"i","s","c"}),
    -- ["<Up>"] = cmp.mapping(function(callback)
    --   if cmp.visible() then
    --     cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
    --   else
    --     fallback()
    --   end
    -- end, {"i","s","c"}),
  },
  -- If no completions from {1}, try {2}
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "async_path", option = { trailing_slash = true } },
    { name = "orgmode" },
  }, {
    --
  }),
}

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "async_path" },
  }, {
    { name = "cmdline" },
  }),
})
