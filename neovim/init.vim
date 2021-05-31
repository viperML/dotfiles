" leader key
let mapleader="\<SPACE>"

call plug#begin()
    Plug 'mg979/vim-visual-multi'
    Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
    Plug 'vim-airline/vim-airline'
    Plug 'glepnir/dashboard-nvim'
    Plug 'junegunn/fzf.vim'
    Plug 'chrisbra/Colorizer'
call plug#end()

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
set clipboard+=unnamedplus

" mouse support
set mouse=a


" CUSTOM MAPPINGS
nnoremap <leader>v <cmd>CHADopen<cr>

" vim-airline config
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '|'

" dashboard + fzf
let g:dashboard_default_executive ='fzf'


