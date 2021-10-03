" leader key
let mapleader="\<SPACE>"

" 4 spaces tabs and indentation
set smartindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" line numbers
set number
set relativenumber

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

" Dracula theme, no background
colorscheme dracula
" No background color
highlight Normal ctermbg=NONE


