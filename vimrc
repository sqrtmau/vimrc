" CORE {{{
" Encoding of current vimscript
scriptencoding utf-8
set nocompatible
" Sets the character encoding used inside Vim
set encoding=utf-8
" Encodings to try when starting to edit an existing file
set fileencodings=utf-8,gbk,gb2312
" Detect the type of file that is edited
filetype on
filetype plugin on
" Use different indent for different type of file
filetype indent on
" Auto reload updated file
set autoread
" Instant search
set incsearch
set ignorecase
set smartcase
" Smooth side scroll
set sidescroll=1
" Correctly show wide unicodes
" set ambiwidth=double
" Mappings timeout
set timeoutlen=1000
" Key codes timeout
set ttimeoutlen=0
" Interval for writing the swapfile to disk
set updatetime=100
set hidden

set splitbelow
set splitright

" Don't show |ins-completion-menu| messages
set shortmess+=c

" Change <leader> (default `\`)
let mapleader=' '
" Change <localleader> (default `\`)
let maplocalleader=' '

" Italic font escape (terminal vim)
" https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic
" set t_ZH=[3m
" set t_ZR=[23m

" [linux/alacritty] True color support in Linux
" https://github.com/alacritty/alacritty/issues/109
if exists('+termguicolors')
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" [linux/alacritty] Mouse not working in Vim
" https://wiki.archlinux.org/index.php/Alacritty#Mouse_not_working_properly_in_Vim
set ttymouse=sgr

" start server
if empty(v:servername) && exists('*remote_startserver')
    call remote_startserver('VIM')
endif
" }}}
" XDG support {{{
" `set rtp^=$XDG_CONFIG_HOME/vim` is in $VIMINIT

if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME  = $HOME."/.cache"       | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME = $HOME."/.config"      | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME   = $HOME."/.local/share" | endif

set runtimepath+=$XDG_CONFIG_HOME/vim/after
set runtimepath+=$XDG_DATA_HOME/vim
set packpath^=$XDG_DATA_HOME/vim

set backupdir=$XDG_CACHE_HOME/vim/backup | call mkdir(&backupdir, 'p', 0700)
set directory=$XDG_CACHE_HOME/vim/swap   | call mkdir(&directory, 'p', 0700)
set undodir=$XDG_CACHE_HOME/vim/undo     | call mkdir(&undodir,   'p', 0700)
set viewdir=$XDG_CACHE_HOME/vim/view     | call mkdir(&viewdir,   'p', 0700)

if !has('nvim') " Neovim has its own special location
    set viminfo+=n$XDG_CACHE_HOME/vim/viminfo
endif

call mkdir($XDG_DATA_HOME."/vim/spell", 'p', 0700)
" }}}
" PLUGINS {{{
" vim-plug {{{
call plug#begin($XDG_DATA_HOME . '/vim/plugged')
Plug 'dstein64/vim-startuptime'
" async language server protocol plugin for vim and neovim
Plug 'prabirshrestha/vim-lsp'
" auto configurations for Language Server for vim-lsp
Plug 'mattn/vim-lsp-settings'
" Dark deno-powered completion framework for neovim/Vim8
Plug 'Shougo/ddc.vim'
" ddc stuffs {{{
" An ecosystem of Vim/Neovim which allows developers to write cross-platform
" plugins in Deno
Plug 'vim-denops/denops.vim'
" Heading matcher for ddc.vim
Plug 'Shougo/ddc-matcher_head'
" Matched rank order sorter for ddc.vim
Plug 'Shougo/ddc-sorter_rank'
" Fuzzy matcher, sorter, and conveter for ddc.vim
Plug 'tani/ddc-fuzzy'
" Around completion for ddc.vim
Plug 'Shougo/ddc-around'
" vim-lsp source for ddc.vim
Plug 'shun/ddc-vim-lsp'
" ultisnips source for ddc.vim
Plug 'matsui54/ddc-ultisnips'
" A source for ddc.vim to gather candidates from tmux panes
Plug 'delphinus/ddc-tmux'
" Buffer source for ddc.vim
Plug 'matsui54/ddc-buffer'
" Powerful and performant file name completion for ddc.vim
Plug 'LumaKernel/ddc-file'
" ddc source for dictionary
Plug 'matsui54/ddc-dictionary'
" }}}
" The ultimate snippet solution for Vim
Plug 'sirver/ultisnips'
" vim-snipmate default snippets
Plug 'honza/vim-snippets'
" Fundemental plugin to handle Nerd Fonts in Vim
Plug 'lambdalisue/nerdfont.vim'
" Directory viewer for Vim
Plug 'justinmk/vim-dirvish'
" File manipulation commands for vim-dirvish
Plug 'roginfarrer/vim-dirvish-dovish'
" Go to Terminal or File manager
Plug 'justinmk/vim-gtfo'
" Best REPL environment for Vim
Plug 'sillybun/vim-repl'
" use CTRL-A/CTRL-X to increment dates, times, and more
Plug 'tpope/vim-speeddating'
" Cycle text within predefined candidates
Plug 'bootleq/vim-cycle'
" Run commands quickly
Plug 'thinca/vim-quickrun'
" Open URI with your favorite browser from your most favorite editor
Plug 'tyru/open-browser.vim'
" A multi-language debugging system for Vim
Plug 'puremourning/vimspector'
" Saves yank history includes unite.vim/denite.nvim history/yank source
Plug 'Shougo/neoyank.vim'
" Tame the quickfix window
Plug 'romainl/vim-qf'
" A Vim plugin for Meson build system
Plug 'igankevich/mesonic'
" Cross-file find and replace
Plug 'brooth/far.vim'
" A command-line fuzzy finder
Plug 'junegunn/fzf'
Plug $HOME . '/Documents/projects/repos/vim-fly'
" A light and configurable statusline/tabline plugin for Vim
Plug 'itchyny/lightline.vim'
" A (Neo)vim plugin for formatting code.
Plug 'sbdchd/neoformat'
" Adds file type icons to Vim plugins
Plug 'ryanoasis/vim-devicons'
" Viewer & Finder for LSP symbols and tags in Vim
Plug 'liuchengxu/vista.vim'
" Vim plugin that provides additional text objects
Plug 'wellle/targets.vim'
" defines a new text object representing lines of code at the same indent level
Plug 'michaeljsmith/vim-indent-object'
" Multi-character pairs, intelligent matching
Plug 'tmsvg/pear-tree'
" Quoting/Parenthesizing made simple
Plug 'tpope/vim-surround'
" Enable repeating supported plugin maps with '.'
Plug 'tpope/vim-repeat'
" Comment stuff out
Plug 'tpope/vim-commentary'
" A Vim alignment plugin
Plug 'junegunn/vim-easy-align'
" Auto-toggle hlsearch, and show number of matches
Plug 'romainl/vim-cool'
" Show a diff using Vim its sign column
Plug 'mhinz/vim-signify'
" The missing motion for Vim
Plug 'justinmk/vim-sneak'
" A vim plugin to perform diffs on blocks of code
Plug 'AndrewRadev/linediff.vim'
" Vim plugin to diff two directories
Plug 'will133/vim-dirdiff'
" 『盘古之白』中文排版自动规范化的 Vim 插件
Plug 'hotoo/pangu.vim'
" A modern vim plugin for editing LaTeX files.
Plug 'lervag/vimtex'
" Asynchronously control git repositories in Neovim/Vim 8
Plug 'lambdalisue/gina.vim'
" emmet for vim: http://emmet.io/
Plug 'mattn/emmet-vim'
" VIM Table Mode for instant table creation.
Plug 'dhruvasagar/vim-table-mode'
" Auto switch input methods
Plug 'brglng/vim-im-select'
" True Sublime Text style multiple selections for Vim
Plug 'mg979/vim-visual-multi'
" Asynchronous translating plugin for Vim/Neovim
Plug 'voldikss/vim-translator'
Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app && yarn install'}
" Filetypes {{{
Plug $HOME . '/Documents/projects/repos/vim-markdown'
Plug 'cespare/vim-toml'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'vim-python/python-syntax'
Plug 'chrisbra/csv.vim'
Plug 'posva/vim-vue'
Plug 'pangloss/vim-javascript'
Plug 'othree/html5.vim'
Plug 'fatih/vim-go'
" Syntax highlighting for generic log files
Plug 'MTDL9/vim-log-highlighting'
Plug 'octol/vim-cpp-enhanced-highlight'
" }}}
" Colorschemes {{{
" A simplified and optimized Gruvbox colorscheme for Vim
Plug 'lifepillar/vim-gruvbox8'
" Gruvbox with Material Palette
Plug 'sainnhe/gruvbox-material'
" A dark Vim/Neovim color scheme inspired by Atom's One Dark syntax theme.
Plug 'joshdick/onedark.vim'
" Clean & Elegant Color Scheme for Vim, Zsh and Terminal Emulators
Plug 'sainnhe/edge'
" An arctic, north-bluish clean and elegant Vim theme
Plug 'arcticicestudio/nord-vim'
" Dark blue color scheme for Vim and Neovim
Plug 'cocopon/iceberg.vim'
" A better color scheme for the late night coder
Plug 'ajmwagar/vim-deus'
" A Vim colorscheme based on Github's syntax highlighting as of 2018.
Plug 'cormacrelf/vim-colors-github'
" Comfortable & Pleasant Color Scheme for Vim
Plug 'sainnhe/everforest'
" }}}
call plug#end()
" }}}
" vim-lsp {{{
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_signs_error = {'text': ''}
let g:lsp_diagnostics_signs_warning = {'text': ''}
let g:lsp_diagnostics_signs_information = {'text': ''}
let g:lsp_diagnostics_signs_hint = {'text': 'ﯦ'}
nmap <silent> [g <Plug>(lsp-previous-diagnostic)
nmap <silent> ]g <Plug>(lsp-next-diagnostic)
nmap <silent> <leader>cr  <Plug>(lsp-rename)
xmap <silent> <leader>cf  <Plug>(lsp-document-range-format)
nmap <silent> <leader>cf  <Plug>(lsp-document-range-format)
nmap <silent> <leader>ca  <Plug>(lsp-code-action)
nmap <silent> <leader>cl  <Plug>(lsp-code-lens)
nmap <silent> gd <Plug>(lsp-definition)
nmap <silent> gy <Plug>(lsp-declaration)
nmap <silent> gi <Plug>(lsp-implementation)
nmap <silent> gr <Plug>(lsp-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        LspHover
    endif
endfunction

augroup clear_preview_popup
    autocmd!
    " close diagnostics float preview on insert mode
    autocmd InsertEnter * call popup_clear()
augroup END

augroup fix_colors
    autocmd!
    autocmd ColorScheme * call s:fix_colors()
augroup END

function! s:fix_colors() abort
    highlight LspErrorHighlight cterm=underline gui=underline
    highlight LspWarningHighlight cterm=underline gui=underline
    highlight link LspErrorText CocErrorSign
    highlight link LspWarningText CocWarningSign
    highlight link LspInformationText CocInfoSign
    highlight link LspHintText CocHintSign
endfunction
" }}}
" vim-lsp-settings {{{
let g:lsp_settings = {}
let s:lsp_completion_item_kinds = {
            \'1': '',
            \'2': 'ﬦ',
            \'3': '',
            \'4': '',
            \'5': '',
            \'6': '',
            \'7': 'פּ',
            \'8': '',
            \'9': '',
            \'10': '',
            \'11': '',
            \'12': '',
            \'13': '',
            \'14': '',
            \'15': '',
            \'16': '',
            \'17': '',
            \'18': '',
            \'19': '',
            \'20': '',
            \'21': '',
            \'22': '',
            \'23': '',
            \'24': '',
            \'25': '',
            \}
for s in ['clangd', 'pyright-langserver', 'vim-language-server', 'texlab', 'deno']
    let g:lsp_settings[s] = {'config': {
                \'completion_item_kinds': s:lsp_completion_item_kinds}}
endfor
let g:lsp_settings['pyright-langserver']['workspace_config'] = {
            \'python': {'analysis': {
                \'autoImportCompletions': v:false,
                \'stubPath': $XDG_CACHE_HOME . '/pyright/typings'
                \}}
                \}
" }}}
" ddc.vim {{{
call ddc#custom#patch_global('sources', [
            \'file',
            \'vim-lsp',
            \'ultisnips',
            \'around',
            \'buffer',
            \'tmux',
            \'dictionary',
            \])
call ddc#custom#patch_global('sourceOptions', {
            \'_': {
                \'ignoreCase': v:true,
                \'matchers': ['matcher_fuzzy'],
                \'sorters': ['sorter_fuzzy'],
                \'converters': ['converter_fuzzy'],
                \},
            \'ultisnips': {'mark': 'US'},
            \'around': {'mark': 'A'},
            \'vim-lsp': {'mark': 'lsp', 'minAutoCompleteLength': 1},
            \'tmux': {'mark': 'tmux'},
            \'buffer': {'mark': 'B'},
            \'dictionary': {'mark': 'D', 'ignoreCase': v:false},
            \'file': {
                \'mark': 'F',
                \'isVolatile': v:true,
                \'forceCompletionPattern': '\S/\S*',
                \'matchers': ['matcher_head'],
                \'sorters': ['sorter_rank'],
                \},
            \})
call ddc#custom#patch_global('sourceParams', {
            \'around': {'maxSize': 500},
            \'buffer': {
                \'requireSameFiletype': v:false,
                \'limitBytes': 5000000,
                \'fromAltBuf': v:true,
                \'forceCollect': v:true,
                \},
            \'dictionary': {
                \'dictPaths': ['/usr/share/dict/words'],
                \'smartCase': v:true,
                \'showMenu': v:false,
                \},
            \'tmux': {'excludeCurrentPane': v:true},
            \'file': {
                \'disableMenu': v:true,
                \'projFromCwdMaxCandidates': [0],
                \'projFromBufMaxCandidates': [0],
                \}
            \})

" <TAB>: completion.
inoremap <silent><expr> <TAB>
\ ddc#map#pum_visible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  ddc#map#pum_visible() ? '<C-p>' : '<C-h>'

" Use ddc.
call ddc#enable()
" }}}
" UltiSnips {{{
let g:UltiSnipsExpandTrigger = '<c-j>'
let g:UltiSnipsListSnippets = '<c-l>'
" }}}
" vim-dirvish {{{
" https://github.com/justinmk/vim-dirvish/issues/145
" call dirvish#add_icon_fn(function('nerdfont#find'))
" list dirs before files
let g:dirvish_mode = 'sort ,^.*[\/],'

augroup dirvish_config
    autocmd!
    " hide dotfiles
    autocmd FileType dirvish nnoremap <silent><buffer> gh
                \ :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>
augroup END
" }}}
" vim-gtfo {{{
let g:gtfo#terminals = {
            \'unix': 'alacritty --working-directory ' . expand("%:p:h") . ' &',
            \}
" }}}
" vimspector {{{
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = [
            \ 'debugpy',
            \ 'vscode-cpptools',
            \ 'vscode-bash-debug'
            \ ]
nmap <Leader>di <Plug>VimspectorBalloonEval
xmap <Leader>di <Plug>VimspectorBalloonEval
" }}}
" vim-repl {{{
let g:repl_program = {
            \ 'python': 'ipython',
            \ 'default': 'zsh',
            \ 'vim': 'vim -e',
            \ }
" }}}
" vim-quickrun {{{
let g:quickrun_config = {}
let g:quickrun_config._ = {
            \ 'runner': 'job',
            \ 'outputter': 'buffered',
            \ 'outputter/buffered/target': 'buffer',
            \ 'outputter/buffer/append': 0,
            \ 'outputter/buffer/close_on_empty': 1,
            \ }
nmap <leader>r <Plug>(quickrun)
vmap <leader>r <Plug>(quickrun)
" }}}
" open-browser.vim {{{
" disable netrw's gx mapping.
let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
" }}}
" csv.vim {{{
let g:csv_comment='#'
" }}}
" pear-tree {{{
" Disable dot-repeatable expansion
let g:pear_tree_repeatable_expand = 0
" Enable smart pairs
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
" }}}
" fzf {{{
let $FZF_DEFAULT_COMMAND="rg --files --hidden --glob='!^node_modules$' --glob='!.git' --glob='!\.*.swp'"
let $FZF_DEFAULT_OPTS="--layout=reverse --info=inline"
" let g:fzf_layout = {
"             \ 'window': {
"                 \ 'width': 0.48,
"                 \ 'height': 0.64,
"                 \ 'highlight': 'Identifier',
"                 \ 'border': 'rounded'
"                 \ }
"                 \ }
" let g:fzf_history_dir = $XDG_CACHE_HOME . '/fzf'

augroup update_bat_theme
    autocmd!
    autocmd ColorScheme * call s:change_bat_theme(expand('<amatch>'))
augroup END]]

function! s:change_bat_theme(scheme)
    let l:default = {'light': 'OneHalfLight', 'dark': 'OneHalfDark'}
    let l:theme_map = {
                \'gruvbox-material': {'light': 'gruvbox-light', 'dark': 'gruvbox-dark'},
                \'gruvbox8': {'light': 'gruvbox-light', 'dark': 'gruvbox-dark'},
                \'gruvbox8_hard': {'light': 'gruvbox-light', 'dark': 'gruvbox-dark'},
                \'gruvbox8_soft': {'light': 'gruvbox-light', 'dark': 'gruvbox-dark'},
                \'nord': {'dark': 'Nord'},
                \'onedark': {'dark': 'OneHalfDark'},
                \'github': {'light': 'GitHub'},
                \}
    let $BAT_THEME = get(get(l:theme_map, a:scheme, l:default),
                \&background, l:default[&background])
endfunction
" }}}
" vim-fly {{{
augroup udpate_fly_colors
    autocmd!
    autocmd ColorScheme * let g:fly_colors = get(g:, 'fzf_colors', {})
augroup END

let g:fly_history_dir = $XDG_CACHE_HOME . '/vim-fly'
noremap <silent> <leader>fb :Fly buffers<CR>
noremap <silent> <leader>ff :Fly files<CR>
noremap <silent> <leader>fh :Fly help<CR>
noremap <silent> <leader>fs :Fly sources<CR>
noremap <silent> <leader>fr :Fly resume<CR>
noremap <silent> <leader>fm :Fly mru<CR>
noremap <silent> <leader>fM :Fly maps<CR>
noremap <silent> <leader>fl :Fly blines<CR>
noremap <silent> <leader>fL :Fly lines<CR>
noremap <silent> <leader>fg :Fly grep<CR>
noremap <silent> <leader>fc :Fly commands<CR>
noremap <silent> <leader>f/ :Fly shist<CR>
noremap <silent> <leader>fy :Fly yanks<CR>
" }}}
" vim-easy-align {{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
vmap <Enter> <Plug>(EasyAlign)
" }}}
" vim-cool {{{
" Show number of matches in the command-line
let g:CoolTotalMatches = 1
" }}}
" vista.vim {{{
nnoremap <silent> <leader>] :Vista!!<CR>
let g:vista_executive_for = {'pandoc': 'markdown'}
" }}}
" neoformat {{{
" Enable alignment
let g:neoformat_basic_format_align = 1
" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1
" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
let g:neoformat_enabled_c = ['clangformat', 'uncrustify', 'astyle']
let g:neoformat_enabled_cpp = ['clangformat', 'uncrustify', 'astyle']
" }}}
" lightline {{{
let g:lightline = {}
" let g:lightline.colorscheme = 'default'
let g:lightline.mode_map = {
            \ 'n':      ' N ',
            \ 'i':      ' I ',
            \ 'R':      ' R ',
            \ 'v':      ' V ',
            \ 'V':      ' V-L ',
            \ "\<C-v>": ' V-B ',
            \ 'c':      ' C ',
            \ 's':      ' S ',
            \ 'S':      ' S-L',
            \ "\<C-s>": ' S-B ',
            \ 't':      ' > ',
            \ }

let g:lightline.component_function = {
            \ 'lsp_status': 'm#util#lsp_status',
            \ }
let g:lightline.active = {
            \ 'left': [['mode', 'paste'],
            \          ['lsp_status', 'readonly', 'filename', 'modified']]
            \ }

augroup update_lightline_colorscheme
    autocmd!
    autocmd ColorScheme * call s:update_lightline_colorscheme(expand('<amatch>'))
augroup END

let s:lightline_colorschemes_map = {
            \'gruvbox-material': 'gruvbox_material',
            \'gruvbox8_hard': 'gruvbox8',
            \'gruvbox8_soft': 'gruvbox8',
            \}

function! s:update_lightline_colorscheme(scheme)
    let l:scheme = get(s:lightline_colorschemes_map, a:scheme, a:scheme)
    execute 'runtime autoload/lightline/colorscheme/' . l:scheme . '.vim'
    if exists('g:lightline#colorscheme#{l:scheme}#palette')
        let g:lightline.colorscheme = l:scheme
    else
        return
    endif
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
endfunction
" }}}
" vim-im-select {{{
" KDE auto switches the IM for apps, disable it
let g:im_select_enable_focus_events = 0
" }}}
" vim-markdown {{{
let g:markdown_fenced_languages = ['bash', 'vim', 'python', 'json', 'tex']
let g:markdown_conceal_link = 0
autocmd! FileType markdown set concealcursor=nc conceallevel=2
" }}}
" vimtex {{{
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
" }}}
" markdown-preview.nvim {{{
function! g:OpenUrl(url) abort
    call job_start(['sh', '-c', 'qutebrowser --target private-window -T -C ~/.config/qutebrowser/config.py ' . shellescape(a:url)])
endfunction
let g:mkdp_auto_close = 0
let g:mkdp_browserfunc = 'g:OpenUrl'
nmap <leader>p <Plug>MarkdownPreviewToggle
" }}}
" python-syntax {{{
let g:python_highlight_all = 1
" }}}
" vim-translator {{{
let g:translator_history_enable = v:true
let g:translator_default_engines = ['haici', 'youdao']
" Display translation in a window
nmap <silent> <Leader><Space> <Plug>TranslateW
vmap <silent> <Leader><Space> <Plug>TranslateWV
" }}}
" vim-sneak {{{
" Disable highlighting for sneak matches
" highlight link Sneak Normal
let g:sneak#s_next = 1
let g:sneak#map_netrw = 0
let g:sneak#use_ic_scs = 1
" }}}
" vim-cycle {{{
let g:cycle_default_groups = [
            \   [['true', 'false']],
            \   [['yes', 'no']],
            \   [['on', 'off']],
            \   [['+', '-']],
            \   [['>', '<']],
            \   [['"', "'"]],
            \   [['==', '!=']],
            \   [['0', '1']],
            \   [['and', 'or']],
            \   [["in", "out"]],
            \   [["up", "down"]],
            \   [["min", "max"]],
            \   [["get", "set"]],
            \   [["add", "remove"]],
            \   [["to", "from"]],
            \   [["read", "write"]],
            \   [["only", "except"]],
            \   [['without', 'with']],
            \   [["exclude", "include"]],
            \   [["asc", "desc"]],
            \   [['是', '否']],
            \   [['{:}', '[:]', '(:)'], 'sub_pairs'],
            \   [['（:）', '「:」', '『:』'], 'sub_pairs'],
            \   [['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
            \     'Friday', 'Saturday'], 'hard_case', {'name': 'Days'}],
            \ ]
" }}}
" vim-qf {{{
let g:qf_mapping_ack_style = 1
nmap <leader>q <Plug>(qf_qf_toggle)
" }}}
" gruvbox-material {{{
let g:gruvbox_material_sign_column_background = 'none'
let g:gruvbox_material_better_performance = 1
" }}}
" netrw (builtin) {{{
" Disable netrw
let g:loaded_netrwPlugin = 1
" let g:netrw_liststyle = 1
" Suppress the banner
" let g:netrw_banner = 0
"" Keep the current directory the same as the browsing directory
" let g:netrw_keepdir = 0
" let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
" let g:netrw_hide = 1
" let g:netrw_home = $XDG_CACHE_HOME . '/vim'
" Preview in vertically split window
" let g:netrw_preview = 1
" }}}
" syntax/tex.vim (builtin) {{{
" Set flavor filetype of .tex file
let g:tex_flavor = 'tex'
let g:tex_conceal = 'abmgs'
" }}}
" }}}
" EDITING {{{
" Copy indent from current line when starting a new line
set autoindent
" Do smart autoindenting when starting a new line
set smartindent
" Disable long line break
set textwidth=0
" Expand `\t` to spaces
set expandtab
" Equivalent column with of `\t`
" set tabstop=8
" Whitespaces for a <TAB>/<BS> key press
set softtabstop=4
" Whitespaces for a level of indentation
set shiftwidth=4
" Allow backspacing over everything in insert mode
set backspace=indent,eol,start
" m: allow break at a multi-byte character above 255
" B: don't insert space between two multi-byte character when join lines
set formatoptions+=mB
" cjk: disable for CJK characters
set spelllang=en_us,cjk
set nospell
" Enable mouse support for: all modes
set mouse=a

" Set tab with for web
augroup tabwidth
    autocmd!
    autocmd FileType html,css,scss,javascript,typescript,vue,json,yaml
                \ setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END
" }}}
" APPEARANCE {{{
syntax enable
" Show the line and column number of the cursor
set ruler
" Show number column
set number
" Plugin `lightline` will handle it
set noshowmode
" Always show statusline
set laststatus=2
" highlight cursorline
set cursorline
" Highlight search results
set hlsearch
" Line width limit
set colorcolumn=80
" True color support
set termguicolors
"" Always show at least one line above/below the cursor
set scrolloff=2
" Show command-line completion menu
set wildmenu
" Command-line completion style: popup menu
set wildoptions=pum
" Display special characters
set listchars=tab:>\ ,trail:·,extends:>,precedes:<,nbsp:+
set list
" Draw the signcolumn
set signcolumn=yes
" [GUI] Fonts
set guifont=SauceCodePro\ Nerd\ Font\ 11
" [GUI] Hide toolbar
set guioptions-=T
" completion menu maximum height
set pumheight=20

" Setting dark mode
set background=dark
" if strftime('%H') >= 6 && strftime('%H') < 18
"     set background=light
" else
"     set background=dark
" endif
colorscheme gruvbox-material
" }}}
" MAPPINGS {{{
" personal mapping flavor
" <leader>c* -> lsp
" <leader>d* -> daily life
" <leader>f* -> fuzzy finder
" <leader>*  -> frequently used commands
" }}}
" vim: tw=78 foldenable foldmethod=marker foldcolumn=1
