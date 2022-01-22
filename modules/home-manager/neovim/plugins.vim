colorscheme one
if strftime("%H") < 18 && strftime("%H") > 5
  set background=light
else
  set background=dark
endif

let g:transparent_enabled = v:true
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
