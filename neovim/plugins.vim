colorscheme dracula

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
