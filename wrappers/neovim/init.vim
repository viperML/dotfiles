" leader key
" let mapleader="\<SPACE>"
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"
nnoremap <Space> <Nop>


" 4 spaces tabs and indentation
set smartindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Per language
augroup indentation
  autocmd!
  autocmd FileType vim setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType nix setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" line numbers
set number
set relativenumber

" spacing when scrolling
set scrolloff=4

" use system clipboard via xsel
" set clipboard+=unnamedplus
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

" mouse support
set mouse=a

" Set the cursor to a line after leaving
au VimLeave * set guicursor=a:ver100

" Fuck Ex mode
:map Q <Nop>

let g:transparent_enabled = v:true
let g:highlightedyank_highlight_duration = 3

" Comes from modeline
set noshowmode
