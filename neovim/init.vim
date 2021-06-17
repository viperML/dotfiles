" leader key
let mapleader="\<SPACE>"

call plug#begin()
    Plug 'mg979/vim-visual-multi'
    " Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
    Plug 'vim-airline/vim-airline'
    Plug 'glepnir/dashboard-nvim'
    Plug 'junegunn/fzf.vim'
    Plug 'chrisbra/Colorizer'
    Plug 'jiangmiao/auto-pairs'
    Plug 'machakann/vim-highlightedyank'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'easymotion/vim-easymotion'
    Plug 'dracula/vim', { 'as': 'dracula' }
    Plug 'preservim/nerdtree'
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
" set clipboard+=unnamedplus
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

" mouse support
set mouse=a

" NERDTree default keybinds
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>


" vim-airline config
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '|'

" dashboard + fzf
let g:dashboard_default_executive ='fzf'

" Reset cursor after leaving vim
au VimLeave * set guicursor=a:ver100

" Plugin highlight yank
" Change highlight duration
let g:highlightedyank_highlight_duration = -1

" Dracula theme, no background
colorscheme dracula
highlight Normal ctermbg=black
