" Get the syntax highlight of the cursor word
function! m#util#synstack()
  if !exists("*synstack")
  return
  endif
  return map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

