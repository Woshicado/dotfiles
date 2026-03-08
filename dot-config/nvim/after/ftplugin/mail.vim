nnoremap <buffer> i <Cmd>TagToggle important<CR>
xnoremap <buffer> i :TagToggle important<CR>
nnoremap <buffer> t <Cmd>TagToggle todo<CR>
xnoremap <buffer> t :TagToggle todo<CR>

nnoremap <buffer> q <Cmd>Bdelete<CR>

" Map ]] and [[ to jump between messages in the thread
nnoremap <buffer> <silent> ]] :call search('^id:.*{{{', 'W')<CR>zt
nnoremap <buffer> <silent> [[ :call search('^id:.*{{{', 'bW')<CR>zt

setlocal syntax=mail
" Load after treesitter since I didn't manage to enable syntax highlighting
" for mail otherwise
call timer_start(0, {-> execute('setlocal syntax=mail')})
