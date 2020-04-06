let s:TODO_REGEX = '- \[[ x]\] '
let s:UNCHECKED_TODO_REGEX = '- \[ \] '
let s:CHECKED_TODO_REGEX = '- \[x\] '
let s:CHECKED_TODO_INDICATOR = '- [x] '
let s:UNCHECKED_TODO_INDICATOR = '- [ ] '
let s:CHILD_INDENTATION_OFFSET = 2


function! s:_check(line, update_children, update_parent)
  call s:check_line(a:line)
  if a:update_children
    call s:check_all_children(a:line)
  endif
  if a:update_parent
    call s:check_parent_if_complete(a:line)
  endif
endfunction


function! s:check()
  call s:_check(line('.'), 1, 1)
endfunction


function! s:check_all_children(line)
  let l:children = s:find_all_children(a:line)
  for l:child in l:children
    call s:_check(l:child, 1, 0)
  endfor
endfunction


function! s:check_parent_if_complete(line)
  let l:parent = s:find_parent(a:line)
  if l:parent == -1
    return
  endif
  let l:children = s:find_all_children(l:parent)
  let l:complete = 1
  for l:child in l:children
    if !s:is_checked(l:child)
      let l:complete = 0
      break
    endif
  endfor
  if l:complete
    call s:_check(l:parent, 0, 1)
  endif
endfunction


function! s:check_line(line)
  call setline(a:line, s:checked_line(a:line))
endfunction


function! s:checked_line(line)
  return substitute(getline(a:line), s:UNCHECKED_TODO_REGEX, s:CHECKED_TODO_INDICATOR, '')
endfunction


function! s:is_checked(line)
  return match(getline(a:line), s:CHECKED_TODO_REGEX)
endfunction


function! s:_uncheck(line, update_children, update_parent)
  call s:uncheck_line(a:line)
  if a:update_children
    call s:uncheck_all_children(a:line)
  endif
  if a:update_parent
    call s:uncheck_parent(a:line)
  endif
endfunction

function! s:uncheck()
  call s:_uncheck(line('.'), 1, 1)
endfunction


function! s:uncheck_all_children(line)
  let l:children = s:find_all_children(a:line)
  for l:child in l:children
    call s:_uncheck(l:child, 1, 0)
  endfor
endfunction

function! s:uncheck_parent(line)
  let l:parent = s:find_parent(a:line)
  if l:parent == -1
    return
  endif
  call s:_uncheck(l:parent, 0, 1)
endfunction


function! s:uncheck_line(line)
  call setline(a:line, s:unchecked_line(a:line))
endfunction


function! s:unchecked_line(line)
  return substitute(getline(a:line), s:CHECKED_TODO_REGEX, s:UNCHECKED_TODO_INDICATOR, '')
endfunction


function! s:find_all_children(line)
  let l:indentation = s:get_indentation(a:line)
  let l:next_line = a:line + 1
  let l:children = []
  while l:next_line <= line('$')
    let l:next_indentation = s:get_indentation(l:next_line)
    if l:next_indentation <= l:indentation
      break
    elseif l:next_indentation == l:indentation + s:CHILD_INDENTATION_OFFSET
      call add(l:children, l:next_line)
    endif
    let l:next_line += 1
  endwhile
  return l:children
endfunction


function! s:find_parent(line)
  let l:indentation = s:get_indentation(a:line)
  let l:next_line = a:line - 1
  while l:next_line >= 1
    let l:next_indentation = s:get_indentation(l:next_line)
    if l:next_indentation == l:indentation - s:CHILD_INDENTATION_OFFSET
      break
    elseif l:next_indentation < l:indentation - s:CHILD_INDENTATION_OFFSET
      let l:next_line = -1
    endif
    let l:next_line -= 1
  endwhile
  return l:next_line
endfunction


function! s:get_indentation(line)
  return match(getline(a:line), s:TODO_REGEX)
endfunction


command! TodoListsCheckTodo call s:check()
command! TodoListsUncheckTodo call s:uncheck()
