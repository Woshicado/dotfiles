call plug#begin(stdpath('data').'/plugged')

" TRUE COLORS
if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
    set termguicolors
endif

" Some options
set cursorline
set number
set expandtab
set shiftwidth=4
set tabstop=4
set background=dark
set scrolloff=5
set cc=80,100
set nowrap
" Allow left/right keys to change lines in normal mode (<,>) and in insert mode ([,]). h,l keys still won't wrap
set whichwrap+=<,>,[,]

" Allow tmuxtree to send lines to other panes
Plug 'kiyoon/tmuxsend.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'ryanoasis/vim-devicons'
Plug 'ap/vim-css-color'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'

Plug 'morhetz/gruvbox'

" Plugin configurations
let g:airline_theme='deus'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

let NERDTreeShowHidden=1

let g:gruvbox_italic=1

" Extra keybinds
let mapleader =  ' ' " Space-Taste als Leader

nnoremap <C-q> :q!<CR>
nnoremap <F4> :bd<CR>
nnoremap <F5> :NERDTreeToggle<CR>
nnoremap <silent> <leader>w :set wrap!<CR> 
" space + w -> toggle wrap
nnoremap <silent> <leader><Left> :bp!<CR>
nnoremap <silent> <leader><Right> :bn!<CR>


autocmd vimenter * ++nested colorscheme gruvbox

call plug#end()
