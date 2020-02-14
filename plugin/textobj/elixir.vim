if exists('g:loaded_textobj_elixir')
  finish
endif
let g:loaded_textobj_elixir = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

call textobj#user#plugin('elixir', {
\   'blocks': {
\     'select-a-function': 'ElixirAround',
\     'select-a': 'ae',
\     'select-i-function': 'ElixirInside',
\     'select-i': 'ie',
\   },
\ })

function! ElixirAround()
  let head_pos = searchpairpos('\<do\>:\@!\|\<fn\>', '', '\<end\>', 'Wbn')
  let tail_pos = searchpairpos('\<do\>:\@!\|\<fn\>', '', '\<end\>', 'Wn')

  let fn_head_pos = searchpairpos('\<fn\>', '', '\<end\>', 'Wbn')
  let fn_tail_pos = searchpairpos('\<fn\>', '', '\<end\>', 'Wn')

  let select_mode = 'V'
  if fn_head_pos == head_pos && fn_tail_pos == tail_pos
    let select_mode = 'v'
  endif

  let [head_line, head_col] = head_pos
  let [tail_line, tail_col] = tail_pos

  return [select_mode, [0, head_line, head_col, 0], [0, tail_line, tail_col + 2, 0]]
endfunction


function! ElixirInside()
  let head_pos = searchpairpos('\<do\>:\@!\|\<fn\>', '', '\<end\>','Wnb')
  let tail_pos = searchpairpos('\<do\>:\@!\|\<fn\>', '', '\<end\>','Wn')

  let fn_head_pos = searchpairpos('\<fn\>', '', '\<end\>','Wnb')
  let fn_tail_pos = searchpairpos('\<fn\>', '', '\<end\>','Wn')

  let select_mode = 'V'
  if fn_head_pos == head_pos && fn_tail_pos == tail_pos
    let select_mode = 'v'
  endif

  let [head_line, head_col] = head_pos
  let [tail_line, tail_col] = tail_pos

  if head_line != 0 && tail_line != 0
    if !(fn_head_pos == head_pos && fn_tail_pos == tail_pos)
      let head_line = head_line + 1
      let tail_line = tail_line - 1
    endif

    return [select_mode, [0, head_line, head_col + 2, 0], [0, tail_line, tail_col - 1, 0]]
  endif

endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
