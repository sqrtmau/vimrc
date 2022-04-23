if exists('g:loaded_init')
  finish
endif

nnoremap <silent> <C-z> :call m#terminal#toggle()<CR>
tnoremap <silent> <C-z> <C-w>:call m#terminal#toggle()<CR>

function! s:defs(commands)
  let prefix = get(g:, 'fzf_command_prefix', '')
  if prefix =~# '^[^A-Z]'
    echoerr 'g:fzf_command_prefix must start with an uppercase letter'
    return
  endif
  for command in a:commands
    let name = ':'.prefix.matchstr(command, '\C[A-Z]\S\+')
    if 2 != exists(name)
      execute substitute(command, '\ze\C[A-Z]', prefix, '')
    endif
  endfor
endfunction

call s:defs([
            \'command! -bang -nargs=* Rg call m#fzf#rg(<q-args>, <bang>0)',
            \'command! -bang Sources call m#fzf#sources(<bang>0)',
            \'command! -bang Mru call m#fzf#mru(<bang>0)',
            \'command! -bang Yank call m#fzf#yank(<bang>0)',
            \])

call m#fzf#register_source({'name': 'Mru', 'desc': 'Most recently used files'})
call m#fzf#register_source({'name': 'Yank', 'desc': 'Yank history'})

noremap <silent> <leader>fs :execute g:fzf_command_prefix . 'Sources'<CR>
noremap <silent> <leader>fm :execute g:fzf_command_prefix . 'Mru'<CR>
noremap <silent> <leader>fy :execute g:fzf_command_prefix . 'Yank'<CR>
