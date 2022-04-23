let s:words = {}

function! ac#sources#buffer#completor(opt, ctx)
    let l:typed = a:ctx['typed']

    call s:refresh_keyword_incremental(a:opt, l:typed)

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

function! ac#sources#buffer#get_source_options(opts)
    return extend({
                \'name': 'buffer',
                \'completor': function('ac#sources#buffer#completor'),
                \'events': ['VimEnter', 'BufWinEnter'],
                \'on_event': function('s:on_event'),
                \'menu': '[buffer]',
                \'max_buffer_size': 5000000,
                \'clear_cache': v:false,
                \'match_chars': 'a-zA-Z\_\-\u4e00-\u9fff',
                \}, a:opts)
endfunction

function! s:should_ignore(opt) abort
    let l:max_buffer_size = a:opt['max_buffer_size']

    if l:max_buffer_size != -1
        let l:buffer_size = line2byte(line('$') + 1)
        if l:buffer_size > l:max_buffer_size
            call asyncomplete#log('asyncomplete#sources#buffer',
                        \'ignoring buffer autocomplete due to large size',
                        \expand('%:p'), l:buffer_size)
            return 1
        endif
    endif

    return 0
endfunction

let s:last_ctx = {}
function! s:on_event(opt, ctx, event) abort
    if s:should_ignore(a:opt) | return | endif

    if index(['VimEnter', 'BufWinEnter'], a:event) != -1
        call s:refresh_keywords(a:opt)
    endif
endfunction

function! s:refresh_keywords(opt) abort
    if a:opt['clear_cache']
        let s:words = {}
    endif
    let l:text = join(getline(1, '$'), "\n")
    for l:word in split(l:text, '[^' . a:opt['match_chars'] . ']\+')
        if len(l:word) > 1
            let s:words[l:word] = 1
        endif
    endfor
    call asyncomplete#log('asyncomplete#buffer', 's:refresh_keywords() complete')
endfunction

function! s:refresh_keyword_incremental(opt, typed) abort
    let l:words = split(a:typed, '[^' . a:opt['match_chars'] . ']\+')[:-2]

    for l:word in l:words
        if len(l:word) > 1
            let s:words[l:word] = 1
        endif
    endfor
endfunction
