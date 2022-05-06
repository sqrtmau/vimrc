" Source registration {{{1
let g:fzf_sources = [
            \ {'name': 'Files', 'desc': 'Files (similar to :FZF)'},
            \ {'name': 'GFiles', 'desc': 'Git files (git ls-files)'},
            \ {'name': 'GFiles?', 'desc': 'Git files (git status)'},
            \ {'name': 'Buffers', 'desc': 'Open buffers'},
            \ {'name': 'Colors', 'desc': 'Color schemes'},
            \ {'name': 'Ag', 'desc': 'Grep with ag'},
            \ {'name': 'Rg', 'desc': 'Grep with rg'},
            \ {'name': 'Lines', 'desc': 'Lines in loaded buffers'},
            \ {'name': 'BLines', 'desc': 'Lines in the current buffer'},
            \ {'name': 'Tags', 'desc': 'Tags in the project (ctags -R)'},
            \ {'name': 'BTags', 'desc': 'Tags in the current buffer'},
            \ {'name': 'Marks', 'desc': 'Marks'},
            \ {'name': 'Windows', 'desc': 'Windows'},
            \ {'name': 'Locate', 'desc': 'locate command output', 'require_args': 1},
            \ {'name': 'History', 'desc': 'v:oldfiles and open buffers'},
            \ {'name': 'History:', 'desc': 'Command history'},
            \ {'name': 'History/', 'desc': 'Search history'},
            \ {'name': 'Snippets', 'desc': 'Snippets (UltiSnips)'},
            \ {'name': 'Commits', 'desc': 'Git commits (requires fugitive.vim)'},
            \ {'name': 'BCommits', 'desc': 'Git commits for the current buffer'},
            \ {'name': 'Commands', 'desc': 'Commands'},
            \ {'name': 'Maps', 'desc': 'Normal mode mappings'},
            \ {'name': 'Helptags', 'desc': 'Help tags'},
            \ {'name': 'Filetypes', 'desc': 'File types'},
            \ ]

function! m#fzf#register_source(source)
    call add(g:fzf_sources, a:source)
endfunction
" }}}
" Helper functions {{{1
function! s:get_source(name)
    for src in g:fzf_sources
        if src.name ==# a:name
            return src
        endif
    endfor
    return {}
endfunction

let s:default_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
" }}}
" Source definition {{{1
" sources {{{2
function! m#fzf#sources(bang)
    return fzf#run(fzf#wrap(
                \ 'sources',
                \ {
                \ 'source': s:sources_source(),
                \ 'sink': function('s:sources_sink'),
                \ 'options': ['--ansi', '--prompt=FZF> '],
                \ },
                \ a:bang
                \ ))
endfunction

function! m#fzf#do()
endfunction

function! s:sources_sink(line)
    if empty(a:line)
        return
    endif
    let name = matchstr(a:line, '\v^[^ ]+')
    let src = s:get_source(name)
    if empty(src)
        return
    endif

    if empty(get(src, 'cmd', ''))
        let cmd = get(g:, 'fzf_command_prefix', '') . name
    else
        let cmd = src.cmd
    endif

    let require_args = get(src, 'require_args', 0)
    if require_args
        call feedkeys(':' . cmd . ' ', 'n')
    else
        execute cmd
        " BUG: buffer weridly goes to insert mode after call fzf#run() in script
        " see also: https://github.com/junegunn/fzf/issues/1116
        stopinsert
    endif
endfunction

function! s:sources_source()
    let sources = []
    let width = 14
    for s in g:fzf_sources
        let spacer = repeat(' ', width - len(s.name))
        let command = '[0m[32m' . s.name . '[0m'
        let description = '[0m[37m' . s.desc . '[0m'
        call add(sources, command . spacer . description)
    endfor
    return sources
endfunction
" }}}
" rg {{{2
function! m#fzf#rg(query, bang)
    return fzf#vim#grep(
                \ 'rg --hidden --smart-case --color=always '
                \ . '--column --line-number '
                \ . '--glob !node_modules --glob !.git '
                \ . shellescape(a:query),
                \ 1,
                \ fzf#vim#with_preview('down', 'ctrl-y'),
                \ a:bang
                \ )
endfunction
" }}}
" yank {{{2
" Require https://github.com/Shougo/neoyank.vim
function! m#fzf#yank(bang)
    let opts = fzf#wrap('yank', {
                \ 'source': s:yank_source(),
                \ 'options': ['--multi', '--no-sort', '--header-lines=1',
                \     '--expect=ctrl-p', '--prompt=Yank> '],
                \ 'sink*': function('s:yank_handler'),
                \ }, a:bang)
    return fzf#run(opts)
endfunction

function! s:yank_source()
    let reg = '"'
    call neoyank#update()
    let histories = neoyank#_get_yank_histories()
    let reg_history = get(histories, reg, [])
    let sources = map(
                \ copy(reg_history),
                \ 'v:val[1] . "    " . v:val[0]')
    return extend(["Type Content (<CTRL-P> to paste before)"], sources)
endfunction

function! s:yank_handler(line)
    if len(a:line) != 2
        return
    endif

    let [action, text] = a:line
    let cmd = action ==# 'ctrl-p' ? 'P' : 'p'

    let parts = split(text, "    ", 1)
    let regtype = parts[0]
    let text = join(parts[1:], "    ")

    let old_reg = getreg('"')
    let old_regtype = getregtype('"')

    call setreg('"', text, regtype)
    try
      execute 'normal ""' . cmd
    finally
      call setreg('"', old_reg, old_regtype)
    endtry
endfunction
" }}}
" mru {{{2
function! m#fzf#mru(bang)
    let opts = fzf#wrap('mru', {
                \'source': s:prepend_icon(s:mru_source()),
                \'options': ['--multi', '--no-sort', '--prompt=MRU> '],
                \}, a:bang)
    let opts['sink*'] = function('s:mru_handler')
    return fzf#run(opts)
endfunction

function! s:mru_source()
    let l:files = copy(v:oldfiles)
    for l:bufnr in range(1, bufnr('$'), 1)
        if buflisted(l:bufnr) && l:bufnr != bufnr('%')
            call insert(l:files, bufname(l:bufnr), 0)
        endif
    endfor

    let l:excludes = ['^$', '\w\+://', '^/\(tmp\|run\)', '.git/']
    call filter(l:files, {val -> val !~ join(l:excludes, '\|')})

    call uniq(l:files, {i1, i2 -> fnamemodify(i1, ':p') !=# fnamemodify(i2, ':p')})

    return l:files
endfunction

function! s:prepend_icon(candidates)
    let l:result = []
    for l:candidate in a:candidates
        let l:path = fnamemodify(l:candidate, ':p')
        let l:filename = fnamemodify(l:path, ':t')
        let l:icon = WebDevIconsGetFileTypeSymbol(l:filename, isdirectory(l:path))
        call add(l:result, printf('%s %s', l:icon, l:candidate))
    endfor
    return l:result
endfunction

function! s:mru_handler(lines)
    if len(a:lines) < 2
        return
    endif

    let action = get(get(g:, 'fzf_action', s:default_action), a:lines[0], 'edit')
    let targets = a:lines[1:]

    function! s:get_fp(line)
        let l:pos = stridx(a:line, ' ')
        let l:file_path = a:line[pos+1:-1]
        return l:file_path
    endfunction

    if len(targets) > 1 && @% ==# ''
        execute 'silent edit' s:get_fp(remove(targets, 0))
    endif

    for line in targets
        execute 'silent' action s:get_fp(line)
    endfor
endfunction
" }}}
" }}}
" vim: fdm=marker
