require("nvim_comment").setup{}

vim.opt.termguicolors = true
require("bufferline").setup{}

require("lspconfig").rnix.setup{}
require('gitsigns').setup()
require('feline').setup()


require("nvim-treesitter.configs").setup {
  ensure_installed = "maintained",

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    -- disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}


vim.opt.list = true
require("indent_blankline").setup {
    --space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}

require('nvim-tree').setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = true,
}
