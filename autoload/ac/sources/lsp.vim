let s:completion_item_kinds = {}

function! ac#sources#lsp#get_source_options(opts)
    let l:defaults={'name': 'lsp',
                \ 'completor': function('ac#sources#lsp#completor'),
                \ 'allowlist': ['*']}
    return extend(l:defaults, a:opts)
endfunction

function! ac#sources#lsp#completor(opt, ctx) abort
    let l:position = lsp#get_position()
    for l:name in lsp#get_server_names()
        let l:server_info = lsp#get_server_info(l:name)
        let l:blocklist = get(l:server_info, 'blocklist', [])
        let l:allowlist = get(l:server_info, 'allowlist', [])
        if index(l:blocklist, a:ctx['filetype']) >= 0
            continue
        endif
        if index(l:allowlist, '*') < 0 && index(l:allowlist, a:ctx['filetype']) < 0
            continue
        endif
        call lsp#send_request(l:name, {
                    \ 'method': 'textDocument/completion',
                    \ 'params': {
                        \   'textDocument': lsp#get_text_document_identifier(),
                        \   'position': l:position,
                        \ },
                        \ 'on_notification': function('s:handle_completion', [lsp#get_server_info(l:name), l:position, a:opt, a:ctx]),
                        \ })
    endfor
endfunction

function! s:handle_completion(server, position, opt, ctx, data) abort
    if lsp#client#is_error(a:data) || !has_key(a:data, 'response') || !has_key(a:data['response'], 'result')
        return
    endif

    let l:options = {
                \ 'server': a:server,
                \ 'position': a:position,
                \ 'response': a:data['response'],
                \ }

    let l:completion_result = lsp#omni#get_vim_completion_items(l:options)

    let l:col = a:ctx['col']
    let l:typed = a:ctx['typed']
    let l:kw = matchstr(l:typed, get(b:, 'asyncomplete_refresh_pattern', '\k\+$'))
    let l:kwlen = len(l:kw)
    let l:startcol = l:col - l:kwlen
    let l:startcol = min([l:startcol, get(l:completion_result, 'startcol', l:startcol)])

    call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, l:completion_result['items'], l:completion_result['incomplete'])
endfunction

