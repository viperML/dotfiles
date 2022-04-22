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
}

-- LSP
require'lspconfig'.rnix.setup{}
