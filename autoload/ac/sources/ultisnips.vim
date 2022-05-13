function! ac#sources#ultisnips#get_source_options(opts)
    let l:defaults={'name': 'ultisnips',
                \ 'completor': function('ac#sources#ultisnips#completor'),
                \ 'menu': '[us]',
                \}
    return extend(l:defaults, a:opts)
endfunction

function! ac#sources#ultisnips#completor(opt, ctx)
    let l:snips = UltiSnips#SnippetsInCurrentScope()

    let l:matches = []

    let l:col = a:ctx['col']
    let l:typed = a:ctx['typed']

    let l:kw = matchstr(l:typed, '\w\+$')
    let l:kwlen = len(l:kw)

    let l:matches = map(keys(l:snips),'{"word":v:val,"abbr":v:val."~","dup":1,"icase":1,"menu":"' . a:opt['menu'] . '", "info": l:snips[v:val]}')
    let l:startcol = l:col - l:kwlen

    call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, l:matches)
endfunction
