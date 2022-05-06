let s:pair = {
\  '"':  '"',
\  '''':  '''',
\}

function! s:strip_pair_characters(base, item) abort
    " Strip pair characters. If pre-typed text is '"', candidates
    " should have '"' suffix.
    let l:item = a:item
    if has_key(s:pair, a:base[0])
        let [l:lhs, l:rhs, l:str] = [a:base[0], s:pair[a:base[0]], l:item['word']]
        if len(l:str) > 1 && l:str[0] ==# l:lhs && l:str[-1:] ==# l:rhs
            let l:item = extend({}, l:item)
            let l:item['word'] = l:str[:-2]
        endif
    endif
    return l:item
endfunction

function! s:sort_sources(a, b) abort
    let l:info_a = asyncomplete#get_source_info(a:a[0])
    let l:info_b = asyncomplete#get_source_info(a:b[0])
    let l:priority_a = get(l:info_a, 'priority', 0)
    let l:priority_b = get(l:info_b, 'priority', 0)
    return l:priority_b - l:priority_a
endfunction

function! ac#ac#preprocessor(options, matches) abort
    let l:items = []
    let l:startcols = []
    let l:all_matches = items(a:matches)
    call sort(l:all_matches, "s:sort_sources")
    for [l:source_name, l:matches] in l:all_matches
        let l:startcol = l:matches['startcol']
        let l:base = a:options['typed'][l:startcol - 1:]
        let l:source_info = asyncomplete#get_source_info(l:source_name)
        if has_key(l:source_info, 'filter')
            let l:result = l:source_info.filter(l:matches, l:startcol, l:base)
            let l:items += l:result[0]
            let l:startcols += l:result[1]
        else
            if empty(l:base)
                for l:item in l:matches['items']
                    call add(l:items, s:strip_pair_characters(l:base, l:item))
                    let l:startcols += [l:startcol]
                endfor
            elseif exists('*matchfuzzypos') && g:asyncomplete_matchfuzzy
                for l:item in matchfuzzypos(l:matches['items'], l:base, {'key':'word'})[0]
                    call add(l:items, s:strip_pair_characters(l:base, l:item))
                    let l:startcols += [l:startcol]
                endfor
            else
                for l:item in l:matches['items']
                    if stridx(l:item['word'], l:base) == 0
                        call add(l:items, s:strip_pair_characters(l:base, l:item))
                        let l:startcols += [l:startcol]
                    endif
                endfor
            endif
        endif
    endfor

    let a:options['startcol'] = min(l:startcols)

    call asyncomplete#preprocess_complete(a:options, l:items)
endfunction

function! ac#ac#lsp_status()
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
