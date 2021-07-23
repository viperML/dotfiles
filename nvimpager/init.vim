set rtp+=~/.config/nvim/plugged/dracula

" leader key
let mapleader="\<SPACE>"


" line numbers
"set number
"set relativenumber

" spacing when scrolling
set scrolloff=4

" use system clipboard ?
" set clipboard+=unnamedplus
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

" mouse support
set mouse=a

" Reset cursor after leaving vim
au VimLeave * set guicursor=a:ver100

" Plugin highlight yank
" Change highlight duration
let g:highlightedyank_highlight_duration = -1

" Dracula theme, no background
" colorscheme dracula
highlight Normal ctermbg=black

" colorscheme dracula
