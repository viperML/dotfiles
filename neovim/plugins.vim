" https://github.com/xiyaowong/nvim-transparent
let g:transparent_enabled = v:true

" https://github.com/terrortylor/nvim-comment
lua require'nvim_comment'.setup()

" vim-airline config
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '|'

" Plugin highlight yank
" Change highlight duration
let g:highlightedyank_highlight_duration = -1
