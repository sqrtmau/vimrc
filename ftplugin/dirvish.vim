" forked from https://github.com/roginfarrer/vim-dirvish-dovish

if exists("b:dirvish_custom_ftplugin")
    finish
endif
let b:dirvish_custom_ftplugin = 1

nmap <buffer> h <Plug>(dirvish_up)
nmap <buffer> l <CR>
nnoremap <silent><buffer> gr :<C-U>Dirvish %<CR>
nnoremap <silent><buffer> gh
            \:silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>

function! s:fn_copyfile(target, destination) abort
    return 'cp ' . shellescape(a:target) . ' ' . shellescape(a:destination)
endfunction

function! s:fn_copydir(target, destination) abort
    return 'cp -r ' . shellescape(a:target) . ' ' . shellescape(a:destination)
endfunction

function! s:fn_move(target, destination) abort
    return 'mv ' . shellescape(a:target) . ' ' . shellescape(a:destination)
endfunction

function! s:fn_remove(target) abort
    return 'trash ' . shellescape(a:target)
endfunction

function! s:fn_rename(target, destination) abort
    return 'mv ' . shellescape(a:target) . ' ' . shellescape(a:destination)
endfunction

" https://stackoverflow.com/a/47051271
function! s:get_visual_selection()
    if mode()=="v"
        let [line_start, column_start] = getpos("v")[1:2]
        let [line_end, column_end] = getpos(".")[1:2]
    else
        let [line_start, column_start] = getpos("'<")[1:2]
        let [line_end, column_end] = getpos("'>")[1:2]
    endif
    if (line2byte(line_start) + column_start)
                \> (line2byte(line_end) + column_end)
        let [line_start, column_start, line_end, column_end] =
                    \[line_end, column_end, line_start, column_start]
    endif
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - 1]
    let lines[0] = lines[0][column_start - 1:]
    return lines
endfunction

function! s:op_newfile() abort
    " Prompt for new filename
    let filename = input('File name: ')
    if trim(filename) == ''
        return
    endif
    " Append filename to the path of the current buffer
    let filepath = expand("%") . filename

    let output = system("touch " . shellescape(filepath))
    if v:shell_error
        call s:echom_error(cmd)
    endif

    " Reload the buffer
    Dirvish %
endfunction

function! s:op_newdir() abort
    let dirname = input('Directory name: ')
    if trim(dirname) == ''
        return
    endif
    let dirpath = expand("%") . dirname
    if isdirectory(dirpath)
        redraw
        echomsg printf('"%s" already exists.', dirpath)
        return
    endif

    let output = system("mkdir -p " . shellescape(dirpath))
    if v:shell_error
        call s:echom_error(output)
    endif

    " Reload the buffer
    Dirvish %
endfunction

function! s:op_remove() abort
    " Grab the line under the cursor. Each line is a filepath
    let target = trim(getline('.'))
    " Feed the filepath to a delete command like, rm or trash
    let check = confirm("Delete ".target, "&Yes\n&No", 2)
    if check != 1
        echo 'Cancelled.'
        return
    endif
    let output = system(s:fn_remove(target))
    if v:shell_error
        call s:echom_error(output)
    endif

    " Reload the buffer
    Dirvish %
endfunction

function! s:op_rename() abort
    let target = trim(getline('.'))
    let filename = fnamemodify(target, ':t')
    let newname = input('Rename: ', filename)
    if empty(newname) || newname ==# filename
        return
    endif
    let cmd = s:fn_rename(target, expand("%") . newname)
    let output = system(cmd)
    if v:shell_error
        call s:echom_error(output)
    endif

    " Reload the buffer
    Dirvish %
endfunction

function! s:is_prev_selections_valid() abort
    if !exists('s:yanked') || len(s:yanked) < 1
        return 0
    endif

    for target in s:yanked
        if target == ''
            return 0
        endif
    endfor

    return 1
endfunction

function! s:prompt_user_for_rename_or_skip(filename) abort
    let ans = confirm(a:filename." already exists.", "&Rename\n&Abort", 2)
    if ans != 1
        return ''
    endif
    return input('Rename to: ', a:filename)
endfunction

function! s:op_move_selected_here() abort
    if !s:is_prev_selections_valid()
        echomsg 'Select a path first!'
        return
    endif

    let cwd = getcwd()
    let dir_dest = expand("%")
    for i in s:yanked
        let item = i
        let filename = fnamemodify(item, ':t')
        let dirname = split(fnamemodify(item, ':p:h'), '/')[-1]

        if isdirectory(item)
            if (isdirectory(dir_dest . dirname))
                let dirname = s:prompt_user_for_rename_or_skip(dirname)
                redraw
                if dirname == ''
                    return
                endif
            endif
            let cmd = s:fn_move(item, dir_dest . dirname)
        else
            if (!empty(glob(dir_dest . filename)))
                let filename = s:prompt_user_for_rename_or_skip(filename)
                redraw
                if filename == ''
                    return
                endif
            endif
            let cmd = s:fn_move(item, dir_dest . filename)
        endif

        let output = system(cmd)
        if v:shell_error
            call s:echom_error(output)
        endif
    endfor

    " Reload the buffer
    Dirvish %
endfunction

function! s:op_copy_selected_here() abort
    if !s:is_prev_selections_valid()
        echomsg 'Select a path first!'
        return
    endif

    let cwd = getcwd()
    let destinationDir = expand("%")

    for i in s:yanked
        let item = i
        let filename = fnamemodify(item, ':t')
        let dirname = split(fnamemodify(item, ':p:h'), '/')[-1]

        if isdirectory(item)
            if (isdirectory(destinationDir . dirname))
                let dirname = s:prompt_user_for_rename_or_skip(dirname)
                redraw
                if dirname == ''
                    return
                endif
            endif
            let cmd = s:fn_copydir(item, destinationDir . dirname)
        else
            if (!empty(glob(destinationDir . filename)))
                let filename = s:prompt_user_for_rename_or_skip(filename)
                redraw
                if filename == ''
                    return
                endif
            endif

            let cmd = s:fn_copyfile(item, destinationDir . filename)
        endif

        let output = system(cmd)
        if v:shell_error
            call s:echom_error(output)
        endif
    endfor

    " Reload the buffer
    Dirvish %
endfunction

function! s:op_select() abort
    let s:yanked = [trim(getline('.'))]
    echo 'Selected '.s:yanked[0]
endfunction

function! s:op_select_v() abort
    let lines = s:get_visual_selection()
    let s:yanked = lines

    let msg = 'Selected ' . len(lines) . ' file(s)'
    echo msg
endfunction

function! s:echom_error(error) abort
    " clear any current cmdline msg
    redraw
    echohl WarningMsg | echomsg a:error | echohl None
endfunction

nnoremap <silent><buffer> mf :<C-U>call <SID>op_newfile()<CR>
nnoremap <silent><buffer> mk :<C-U>call <SID>op_newdir()<CR>
nnoremap <silent><buffer> R :<C-U>call <SID>op_rename()<CR>
nnoremap <silent><buffer> D :<C-U>call <SID>op_remove()<CR>
nnoremap <silent><buffer> Y :<C-U>call <SID>op_select()<CR>
xnoremap <silent><buffer> Y :<C-U>call <SID>op_select_v()<CR>
nnoremap <silent><buffer> P :<C-U>call <SID>op_copy_selected_here()<CR>
nnoremap <silent><buffer> M :<C-U>call <SID>op_move_selected_here()<CR>
