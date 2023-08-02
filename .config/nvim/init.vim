call plug#begin(stdpath('data').'/plugged')

" Allow left/right keys to change lines in normal mode (<,>) and in insert mode ([,]). h,l keys still won't wrap
set whichwrap+=<,>,[,]

" Allow tmuxtree to send lines to other panes
Plug 'kiyoon/tmuxsend.vim'

call plug#end()
