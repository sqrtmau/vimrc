" Get the syntax highlight of the cursor word
function! m#util#synstack()
  if !exists("*synstack")
  return
  endif
  return map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

function! m#util#lsp_status()
    const status = lsp#get_buffer_diagnostics_counts()
    let msg = ''
    let num = status['error']
    let icon = g:lsp_diagnostics_signs_error['text']
    if  num != 0
        let msg .= icon . ' ' . num
    endif
    let num = status['warning']
    let icon = g:lsp_diagnostics_signs_warning['text']
    if status['warning'] != 0
        if !empty(msg)
            let msg .= ' '
        endif
        let msg .= icon . ' ' . num
    endif
    return msg
endfunction
