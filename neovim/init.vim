" leader key
let mapleader="\<SPACE>"

call plug#begin()

    if exists('g:vscode')
        " VSCode - only extensions
        Plug 'asvetliakov/vim-easymotion', { 'as': 'vsc-easymotion' }
    else
        " Nvim - only extensions
        Plug 'mg979/vim-visual-multi'
        Plug 'easymotion/vim-easymotion'
        Plug 'vim-airline/vim-airline'
        Plug 'glepnir/dashboard-nvim'
        Plug 'junegunn/fzf.vim'
        Plug 'chrisbra/Colorizer'
        Plug 'jiangmiao/auto-pairs'
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
        Plug 'dracula/vim', { 'as': 'dracula' }
        " Plug 'preservim/nerdtree'
    endif

    " Common extensions
    Plug 'machakann/vim-highlightedyank'
    Plug 'terrortylor/nvim-comment'

call plug#end()

" nvim-comment setup
lua require'nvim_comment'.setup()

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
" nnoremap <leader>n :NERDTreeFocus<CR>
" nnoremap <C-n> :NERDTree<CR>
" nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFind<CR>


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
" No background color
highlight Normal ctermbg=NONE
