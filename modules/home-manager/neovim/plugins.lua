vim.cmd [[colorscheme one]]
local current_time = tonumber(os.date "%H%M")
if current_time < 1800 and current_time > 500 then
  colorscheme = "light"
else
  colorscheme = "dark"
end

vim.opt.background = colorscheme

require("nvim_comment").setup {}

vim.opt.termguicolors = true
require("bufferline").setup {
  options = {
    right_mouse_command = nil,
    middle_mouse_command = "bdelete! %d",
    indicator_icon = " ",
  },
}

-- require("lspconfig").rnix.setup{}
require("gitsigns").setup {}

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

require("lualine").setup {
  options = {
    theme = "one" .. colorscheme,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  -- sections = {
  --   lualine_a = {'mode'},
  --   lualine_b = {'branch', 'diff', 'diagnostics'},
  --   lualine_c = {'filename'},
  --   lualine_x = {'encoding', 'fileformat', 'filetype'},
  --   lualine_y = {'progress'},
  --   lualine_z = {'location'}
  -- },
  -- inactive_sections = {
  --   lualine_a = {},
  --   lualine_b = {},
  --   lualine_c = {'filename'},
  --   lualine_x = {'location'},
  --   lualine_y = {},
  --   lualine_z = {}
  -- },
  -- tabline = {},
  -- extensions = {}
}
