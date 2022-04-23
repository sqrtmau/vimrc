function! s:terminal_view(mode)
    if a:mode == 0
        let w:__terminal_view__ = winsaveview()
    elseif exists('w:__terminal_view__')
        call winrestview(w:__terminal_view__)
        unlet w:__terminal_view__
    endif
endfunction

function! m#terminal#open()
    let bid = get(t:, '__terminal_bid__', -1)
    let pos = get(g:, 'm#terminal#pos', 'rightbelow')
    let height = get(g:, 'm#terminal#height', 12)
    let succeed = 0
    let uid = win_getid()
    noautocmd windo call s:terminal_view(0)
    noautocmd call win_gotoid(uid)
    if bid > 0
        let name = bufname(bid)
        if name != ''
            let wid = bufwinnr(bid)
            if wid < 0
                exec pos . ' ' . height . 'split'
                exec 'b '. bid
                if mode() != 't'
                    exec "normal i"
                endif
            else
                exec "normal ". wid . "\<c-w>w"
            endif
            let succeed = 1
        endif
    endif
    let cd = haslocaldir()? ((haslocaldir() == 1)? 'lcd' : 'tcd') : 'cd'
    if succeed == 0
        let savedir = getcwd()
        let workdir = (expand('%') == '')? getcwd() : expand('%:p:h')
        silent execute cd . ' ' . fnameescape(workdir)

        let shell = get(g:, 'm#terminal#shell', '')
        exec pos . ' term ' . ' ++norestore ++rows=' . height . ' ' . shell
        setlocal nonumber norelativenumber signcolumn=no

        silent execute cd . ' '. fnameescape(savedir)
        let t:__terminal_bid__ = bufnr('')
        setlocal bufhidden=hide
        if get(g:, 'terminal_list', 1) == 0
            setlocal nobuflisted
        endif
    endif
    let x = win_getid()
    noautocmd windo call s:terminal_view(1)
    noautocmd call win_gotoid(uid)
    noautocmd call win_gotoid(x)
endfunction

function! m#terminal#close()
    let bid = get(t:, '__terminal_bid__', -1)
    if bid < 0
        return
    endif
    let name = bufname(bid)
    if name == ''
        return
    endif
    let wid = bufwinnr(bid)
    if wid < 0
        return
    endif
    let sid = win_getid()
    noautocmd windo call s:terminal_view(0)
    call win_gotoid(sid)
    if wid != winnr()
        let uid = win_getid()
        exec "normal ". wid . "\<c-w>w"
        close
        call win_gotoid(uid)
    else
        close
    endif
    let sid = win_getid()
    noautocmd windo call s:terminal_view(1)
    call win_gotoid(sid)
endfunction

function! m#terminal#toggle()
    let bid = get(t:, '__terminal_bid__', -1)
    let alive = 0
    if bid > 0 && bufname(bid) != ''
        let alive = (bufwinnr(bid) > 0)? 1 : 0
    endif
    if alive == 0
        call m#terminal#open()
    else
        call m#terminal#close()
    endif
endfunction
