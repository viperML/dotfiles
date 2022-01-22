colorscheme one
if strftime("%H") < 18 && strftime("%H") > 5
  set background=light
else
  set background=dark
endif

" https://github.com/xiyaowong/nvim-transparent
let g:transparent_enabled = v:true

" https://github.com/terrortylor/nvim-comment
lua require'nvim_comment'.setup()

" vim-airline config
" let g:airline#extensions#tabline#left_sep = ''
" let g:airline#extensions#tabline#left_alt_sep = '|'

" Plugin highlight yank
" Change highlight duration
let g:highlightedyank_highlight_duration = 3

" coc config
" Use tab for completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" LSP
lua << EOF
require'lspconfig'.rnix.setup{}
EOF

" bugfferline setup
set termguicolors
lua << EOF
require("bufferline").setup{}
EOF

lua << EOF
require('gitsigns').setup()
require('feline').setup()
EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
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
EOF

" -- vim.opt.listchars:append("space:⋅")
" -- vim.opt.listchars:append("eol:↴")
lua << EOF
vim.opt.list = true

require("indent_blankline").setup {
    --space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}
EOF


lua << EOF
require('nvim-tree').setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = true,
}
EOF
