
" Make sure jumping changes the viewpoint fittingly
execute "nnoremap <silent> <buffer> ]] :<C-U>call <SID>Python_jump('n', '". b:next_toplevel."', 'W', v:count1)<cr>zt"
execute "nnoremap <silent> <buffer> [[ :<C-U>call <SID>Python_jump('n', '". b:prev_toplevel."', 'Wb', v:count1)<cr>zt"
execute "nnoremap <silent> <buffer> ][ :<C-U>call <SID>Python_jump('n', '". b:next_endtoplevel."', 'W', v:count1, 0)<cr>zb"
execute "nnoremap <silent> <buffer> [] :<C-U>call <SID>Python_jump('n', '". b:prev_endtoplevel."', 'Wb', v:count1, 0)<cr>zb"
execute "nnoremap <silent> <buffer> ]m :<C-U>call <SID>Python_jump('n', '". b:next."', 'W', v:count1)<cr>zt"
execute "nnoremap <silent> <buffer> [m :<C-U>call <SID>Python_jump('n', '". b:prev."', 'Wb', v:count1)<cr>zt"
execute "nnoremap <silent> <buffer> ]M :<C-U>call <SID>Python_jump('n', '". b:next_end."', 'W', v:count1, 0)<cr>zb"
execute "nnoremap <silent> <buffer> [M :<C-U>call <SID>Python_jump('n', '". b:prev_end."', 'Wb', v:count1, 0)<cr>zb"

execute "onoremap <silent> <buffer> ]] :call <SID>Python_jump('o', '". b:next_toplevel."', 'W', v:count1)<cr>zt"
execute "onoremap <silent> <buffer> [[ :call <SID>Python_jump('o', '". b:prev_toplevel."', 'Wb', v:count1)<cr>zt"
execute "onoremap <silent> <buffer> ][ :call <SID>Python_jump('o', '". b:next_endtoplevel."', 'W', v:count1, 0)<cr>zb"
execute "onoremap <silent> <buffer> [] :call <SID>Python_jump('o', '". b:prev_endtoplevel."', 'Wb', v:count1, 0)<cr>zb"
execute "onoremap <silent> <buffer> ]m :call <SID>Python_jump('o', '". b:next."', 'W', v:count1)<cr>zt"
execute "onoremap <silent> <buffer> [m :call <SID>Python_jump('o', '". b:prev."', 'Wb', v:count1)<cr>zt"
execute "onoremap <silent> <buffer> ]M :call <SID>Python_jump('o', '". b:next_end."', 'W', v:count1, 0)<cr>zb"
execute "onoremap <silent> <buffer> [M :call <SID>Python_jump('o', '". b:prev_end."', 'Wb', v:count1, 0)<cr>zb"

execute "xnoremap <silent> <buffer> ]] :call <SID>Python_jump('x', '". b:next_toplevel."', 'W', v:count1)<cr>zt"
execute "xnoremap <silent> <buffer> [[ :call <SID>Python_jump('x', '". b:prev_toplevel."', 'Wb', v:count1)<cr>zt"
execute "xnoremap <silent> <buffer> ][ :call <SID>Python_jump('x', '". b:next_endtoplevel."', 'W', v:count1, 0)<cr>zb"
execute "xnoremap <silent> <buffer> [] :call <SID>Python_jump('x', '". b:prev_endtoplevel."', 'Wb', v:count1, 0)<cr>zb"
execute "xnoremap <silent> <buffer> ]m :call <SID>Python_jump('x', '". b:next."', 'W', v:count1)<cr>zt"
execute "xnoremap <silent> <buffer> [m :call <SID>Python_jump('x', '". b:prev."', 'Wb', v:count1)<cr>zt"
execute "xnoremap <silent> <buffer> ]M :call <SID>Python_jump('x', '". b:next_end."', 'W', v:count1, 0)<cr>zb"
execute "xnoremap <silent> <buffer> [M :call <SID>Python_jump('x', '". b:prev_end."', 'Wb', v:count1, 0)<cr>zb"


if !exists('*<SID>Python_jump')
  fun! <SID>Python_jump(mode, motion, flags, count, ...) range
      let l:startofline = (a:0 >= 1) ? a:1 : 1

      if a:mode == 'x'
          normal! gv
      endif

      if l:startofline == 1
          normal! 0
      endif

      let cnt = a:count
      mark '
      while cnt > 0
          call search(a:motion, a:flags)
          let cnt = cnt - 1
      endwhile

      if l:startofline == 1
          normal! ^
      endif
  endfun
endif







let b:undo_ftplugin = '|silent! nunmap <buffer> [M'
      \ . '|silent! nunmap <buffer> [['
      \ . '|silent! nunmap <buffer> []'
      \ . '|silent! nunmap <buffer> [m'
      \ . '|silent! nunmap <buffer> ]M'
      \ . '|silent! nunmap <buffer> ]['
      \ . '|silent! nunmap <buffer> ]]'
      \ . '|silent! nunmap <buffer> ]m'
      \ . '|silent! ounmap <buffer> [M'
      \ . '|silent! ounmap <buffer> [['
      \ . '|silent! ounmap <buffer> []'
      \ . '|silent! ounmap <buffer> [m'
      \ . '|silent! ounmap <buffer> ]M'
      \ . '|silent! ounmap <buffer> ]['
      \ . '|silent! ounmap <buffer> ]]'
      \ . '|silent! ounmap <buffer> ]m'
      \ . '|silent! xunmap <buffer> [M'
      \ . '|silent! xunmap <buffer> [['
      \ . '|silent! xunmap <buffer> []'
      \ . '|silent! xunmap <buffer> [m'
      \ . '|silent! xunmap <buffer> ]M'
      \ . '|silent! xunmap <buffer> ]['
      \ . '|silent! xunmap <buffer> ]]'
      \ . '|silent! xunmap <buffer> ]m'
      \ . '|unlet! b:undo_ftplugin'









" LUA BINDINGS >> ISSUE IS VERY MAGIC MODE IN REGEXES
" SEARCH: 'ignorecase', 'smartcase' and 'magic' are used. -> REMOVE THE \v
" flags for lua to work!

"local map = vim.keymap.set
"
"---- from ~/dotfiles/.local/bin/nvim/share/nvim/runtime/ftplugin/python.vim:
"-- execute "nnoremap <silent> <buffer> ]] :<C-U>call <SID>Python_jump('n', '". b:next_toplevel."', 'W', v:count1)<cr>"
"-- execute "nnoremap <silent> <buffer> [[ :<C-U>call <SID>Python_jump('n', '". b:prev_toplevel."', 'Wb', v:count1)<cr>"
"-- execute "nnoremap <silent> <buffer> ][ :<C-U>call <SID>Python_jump('n', '". b:next_endtoplevel."', 'W', v:count1, 0)<cr>"
"-- execute "nnoremap <silent> <buffer> [] :<C-U>call <SID>Python_jump('n', '". b:prev_endtoplevel."', 'Wb', v:count1, 0)<cr>"
"-- execute "nnoremap <silent> <buffer> ]m :<C-U>call <SID>Python_jump('n', '". b:next."', 'W', v:count1)<cr>"
"-- execute "nnoremap <silent> <buffer> [m :<C-U>call <SID>Python_jump('n', '". b:prev."', 'Wb', v:count1)<cr>"
"-- execute "nnoremap <silent> <buffer> ]M :<C-U>call <SID>Python_jump('n', '". b:next_end."', 'W', v:count1, 0)<cr>"
"-- execute "nnoremap <silent> <buffer> [M :<C-U>call <SID>Python_jump('n', '". b:prev_end."', 'Wb', v:count1, 0)<cr>"
"
"
"local function Python_jump(mode, motion, flags, count, startofline)
"  startofline = startofline or 1  -- Default to 1 if not provided
"
"  if mode == 'x' then
"    vim.cmd("normal! gv")  -- Reselect visual selection
"  end
"
"  if startofline == 1 then
"    vim.cmd("normal! 0")  -- Move to beginning of line
"  end
"
"  vim.cmd("mark '")  -- Set jump mark
"
"  for _ = 1, count do
"    vim.fn.search(motion, flags)
"  end
"
"  if startofline == 1 then
"    vim.cmd("normal! ^")  -- Move to first non-blank character
"  end
"end
"
"
"vim.b.next_toplevel=[[\v%$\|^(class\|def\|async def)>]]
"vim.b.prev_toplevel=[[\v^(class\|def\|async def)>]]
"vim.b.next_endtoplevel=[[\v%$\|\S.*\n+(def\|class)]]
"vim.b.prev_endtoplevel=[[\v\S.*\n+(def\|class)]]
"vim.b.next=[[\v%$\|^\s*(class\|def\|async def)>]]
"vim.b.prev=[[\v^\s*(class\|def\|async def)>]]
"vim.b.next_end=[[\v\S\n*(%$\|^(\s*\n*)*(class\|def\|async def)\|^\S)]]
"vim.b.prev_end=[[\v\S\n*(^(\s*\n*)*(class\|def\|async def)\|^\S)]]
"
"local jump_opts = { silent = true, buffer = true }
"map("n", "]]", function() Python_jump('n', vim.b.next_toplevel, 'W', vim.v.count1) end, jump_opts)
"map("n", "[[", function() Python_jump('n', vim.b.prev_toplevel, 'Wb', vim.v.count1) end, jump_opts)
"map("n", "][", function() Python_jump('n', vim.b.next_endtoplevel, 'W', vim.v.count1, 0) end, jump_opts)
"map("n", "[]", function() Python_jump('n', vim.b.prev_endtoplevel, 'Wb', vim.v.count1, 0) end, jump_opts)
"map("n", "]m", function() Python_jump('n', vim.b.next, 'W', vim.v.count1) end, jump_opts)
"map("n", "[m", function() Python_jump('n', vim.b.prev, 'Wb', vim.v.count1) end, jump_opts)
"map("n", "]M", function() Python_jump('n', vim.b.next_end, 'W', vim.v.count1, 0) end, jump_opts)
"map("n", "[M", function() Python_jump('n', vim.b.prev_end, 'Wb', vim.v.count1, 0) end, jump_opts)
