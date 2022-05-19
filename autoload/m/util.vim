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

function! s:echom_warn(message)
    echohl WarningMsg
    echom a:message
    echohl None
    return 0
endfunction

" Ref: https://retorque.re/zotero-better-bibtex/citing/cayw/
function! m#util#zotero_cite() abort
    if !executable('curl')
        call s:echom_warn('curl not found')
        return
    endif

    let formats = {
                \'markdown': 'formatted-bibliography',
                \'pandoc': 'pandoc&brackets=1',
                \'tex': 'latex',
                \}
    let format = get(formats, &filetype, 'formatted-bibliography')
    let api_call = 'http://127.0.0.1:23119/better-bibtex/cayw?format=' . format
    try
        silent let ref = system('curl -s ' . shellescape(api_call))
    finally
        if v:shell_error
            call s:echom_warn('zotero not running')
            return
        endif
    endtry

    if !empty(ref)
        let line = getline('.')
        call setline('.',
                    \strpart(line, 0, col('.') - 1)
                    \. ref
                    \. strpart(line, col('.') - 1))
    endif
endfunction
