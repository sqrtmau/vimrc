if exists('g:loaded_m')
    finish
endif
let g:loaded_m = 1

nnoremap <silent> <C-z> :call m#terminal#toggle()<CR>
tnoremap <silent> <C-z> <C-w>:call m#terminal#toggle()<CR>

noremap <silent> <leader>z :call m#util#zotero_cite()<CR>
inoremap <silent> <C-z> <C-o>:call m#util#zotero_cite()<CR>
