let s:words = {}
let s:buf_caches = {}

function! ac#sources#buffer#get_source_options(opts)
    return extend({
                \'name': 'buffer',
                \'completor': function('ac#sources#buffer#completor'),
                \'menu': '[buffer]',
                \'max_buffer_size': 5000000,
                \'match_chars': 'a-zA-Z\_\-\u4e00-\u9fff',
                \}, a:opts)
endfunction

function! ac#sources#buffer#completor(opt, ctx)
    let l:typed = a:ctx['typed']

    call s:refresh_words(a:opt, a:ctx)

    if empty(s:words)
        return
    endif

    let l:matches = []

    let l:col = a:ctx['col']

    let l:kw = matchstr(l:typed, '[' . a:opt['match_chars'] . ']\+$')
    let l:kwlen = len(l:kw)

    let l:matches = map(keys(s:words),'{"word":v:val,"dup":1,"icase":1,"menu": "' . a:opt['menu'] . '"}')
    let l:startcol = l:col - l:kwlen

    call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, l:matches)
endfunction

function! s:refresh_words(opt, ctx) abort
    let l:bufs = getbufinfo({'buflisted': 1})
    for l:buf in l:bufs
        let l:bufnr = l:buf['bufnr']
        let l:start = 1
        let l:end = '$'
        if l:bufnr == a:ctx['bufnr']
            let l:start = max([a:ctx['lnum'] - 1000, 1])
            let l:end = a:ctx['lnum'] + 1000
        else
            let l:name = l:buf['name']
            if getfsize(l:name) > a:opt['max_buffer_size']
                continue
            endif
            let l:ftime = getftime(l:name)
            if has_key(s:buf_caches, l:bufnr) && l:ftime <= s:buf_caches[l:bufnr]
                continue
            endif
            let s:buf_caches[l:bufnr] = l:ftime
        endif

        let l:text = join(getbufline(l:bufnr, l:start, l:end), "\n")
        for l:word in split(l:text, '[^' . a:opt['match_chars'] . ']\+')
            if len(l:word) > 1
                let s:words[l:word] = 1
            endif
        endfor
    endfor
    let l:cur_wrods = split(a:ctx['typed'], '[^' . a:opt['match_chars'] . ']\+')
    if !empty(l:cur_wrods)
        call remove(s:words, l:cur_wrods[-1])
    endif
endfunction

