if exists("g:loaded_vim_tailwind")
  finish
endif
let g:loaded_vim_tailwind = 1

let s:classes = tailwind#data#classes()

function! tailwind#complete(findstart, base)
  if a:findstart
    " locate the start of class or previous class
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && (line[start - 1] =~ '\w' || line[start - 1] =~ ':' || line[start - 1] =~ '-')
      let start -= 1
    endwhile
    return start
  elseif empty(a:base)
    return s:classes
  else
    let res = []
    let regex = '^' . substitute(a:base, "[-:]", ".", "g")
    for s in s:classes
      if s["word"] =~ regex
        call add(res, s)
      endif
    endfor
    return res
  endif
endfunction
