" CORE {{{1
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

" XDG support {{{1
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
" PLUGINS {{{1
" vim-plug {{{2
call plug#begin($XDG_DATA_HOME.'/vim/plugged')
Plug 'sillybun/vim-repl'
" use CTRL-A/CTRL-X to increment dates, times, and more
Plug 'tpope/vim-speeddating'
" Cycle text within predefined candidates
Plug 'bootleq/vim-cycle'
Plug 'thinca/vim-quickrun'
Plug 'tyru/open-browser.vim'
Plug 'puremourning/vimspector'
Plug 'Shougo/neoyank.vim'
Plug 'tpope/vim-vinegar'
" Tame the quickfix window
Plug 'romainl/vim-qf'
" Intellisense engine for vim8 & neovim,
" full language server protocol support as VSCode
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'igankevich/mesonic'
" Cross-file find and replace
Plug 'brooth/far.vim'
" A command-line fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" A light and configurable statusline/tabline plugin for Vim
Plug 'itchyny/lightline.vim'
" A (Neo)vim plugin for formatting code.
Plug 'sbdchd/neoformat'
" The ultimate snippet solution for Vim
Plug 'sirver/ultisnips'
" vim-snipmate default snippets
Plug 'honza/vim-snippets'
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
" Rainbow Parentheses Improved
Plug 'luochen1990/rainbow'
" Asynchronous translating plugin for Vim/Neovim
Plug 'voldikss/vim-translator'
Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app && yarn install'}
" Polyglot {{{3
Plug '~/Documents/projects/1-maintaining/vim-markdown'
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
" Themes {{{3
" A simplified and optimized Gruvbox colorscheme for Vim
Plug 'lifepillar/vim-gruvbox8'
Plug 'rakr/vim-one'
Plug 'sonph/onehalf', {'rtp': 'vim'}
" Clean & Elegant Color Scheme for Vim, Zsh and Terminal Emulators
Plug 'sainnhe/edge'
" An arctic, north-bluish clean and elegant Vim theme
Plug 'arcticicestudio/nord-vim'
" Dark blue color scheme for Vim and Neovim
Plug 'cocopon/iceberg.vim'
" A better color scheme for the late night coder
Plug 'ajmwagar/vim-deus'
Plug 'nanotech/jellybeans.vim'
Plug 'crusoexia/vim-monokai'
Plug 'cormacrelf/vim-colors-github'
Plug 'sainnhe/forest-night'
" }}}
call plug#end()

" UltiSnips {{{2
let g:UltiSnipsExpandTrigger = '<c-j>'
let g:UltiSnipsListSnippets = '<c-l>'
" }}}
" coc.nvim {{{2
let g:coc_config_home = $XDG_CONFIG_HOME . '/coc'
let g:coc_data_home = $XDG_DATA_HOME . '/coc'
let g:coc_status_error_sign = ' '
let g:coc_status_warning_sign = ' '

let g:coc_global_extensions = [
            \ "coc-browser",
            \ "coc-calc",
            \ "coc-clangd",
            \ "coc-css",
            \ "coc-emoji",
            \ "coc-highlight",
            \ "coc-html",
            \ "coc-json",
            \ "coc-marketplace",
            \ "coc-pyright",
            \ "coc-rls",
            \ "coc-sh",
            \ "coc-svg",
            \ "coc-tag",
            \ "coc-texlab",
            \ "coc-tsserver",
            \ "coc-ultisnips",
            \ "coc-vetur",
            \ "coc-vimlsp",
            \ "coc-word",
            \ "coc-yaml",
            \ "coc-webpack",
            \]

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> <leader>cR  <Plug>(coc-rename)
nmap <silent> <leader>cr  <Plug>(coc-refactor)
xmap <silent> <leader>cf  <Plug>(coc-format-selected)
nmap <silent> <leader>cf  <Plug>(coc-format-selected)
xmap <silent> <leader>cas <Plug>(coc-codeaction-selected)
nmap <silent> <leader>cas <Plug>(coc-codeaction-selected)
nmap <silent> <leader>ca  <Plug>(coc-codeaction)
nmap <silent> <leader>cqf <Plug>(coc-fix-current)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> <leader>cl  :<C-u>CocList<cr>
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
nnoremap <silent> <leader>ce  :<C-u>CocList extensions<cr>
nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
nnoremap <silent> <leader>cp  :<C-u>CocListResume<cr>
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Use tab for trigger completion with characters ahead and navigate.
" Validate the mappings with command ':verbose imap <tab>'
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" }}}
" vimspector {{{2
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
" vim-quickrun {{{2
let g:quickrun_config = {}
let g:quickrun_config._ = {
            \ 'runner': 'job',
            \ 'outputter': 'buffered',
            \ 'outputter/buffered/target': 'buffer',
            \ 'outputter/buffer/append': 0,
            \ 'outputter/buffer/close_on_empty': 1,
            \ }
" }}}
" open-browser.vim {{{2
" disable netrw's gx mapping.
let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
" }}}
" vim-workspace {{{2
let g:workspace_session_disable_on_args = 1
let g:workspace_session_directory = $XDG_CACHE_HOME . '/vim/sessions/'
" }}}
" csv.vim {{{2
let g:csv_comment='#'
" }}}
" pear-tree {{{2
" Disable dot-repeatable expansion
let g:pear_tree_repeatable_expand = 0
" Enable smart pairs
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
" }}}
" fzf {{{2
let $FZF_DEFAULT_COMMAND="rg --files --hidden --glob='!^node_modules$' --glob='!.git' --glob='!\.*.swp'"
let $FZF_DEFAULT_OPTS="--layout=reverse --info=inline"
let g:fzf_layout = {
            \ 'window': {
            \ 'width': 0.64,
            \ 'height': 0.48,
            \ 'highlight': 'Identifier',
            \ 'border': 'rounded'
            \ }
            \ }
let g:fzf_history_dir = '~/.cache/fzf'
" }}}
" fzf.vim {{{2
let g:fzf_command_prefix = 'Fzf'

noremap <silent> <leader>fc
            \ :execute get(g:, 'fzf_command_prefix', '') . 'Commands'<CR>
noremap <silent> <leader>fb
            \ :execute get(g:, 'fzf_command_prefix', '') . 'Buffers'<CR>
noremap <silent> <leader>ff
            \ :execute get(g:, 'fzf_command_prefix', '') . 'Files'<CR>
noremap <silent> <leader>fF
            \ :execute get(g:, 'fzf_command_prefix', '') . 'GFiles'<CR>
noremap <silent> <leader>fg
            \ :execute get(g:, 'fzf_command_prefix', '') . 'Rg'<CR>
noremap <silent> <leader>fh
            \ :execute get(g:, 'fzf_command_prefix', '') . 'Helptags'<CR>
noremap <silent> <leader>fl
            \ :execute get(g:, 'fzf_command_prefix', '') . 'BLines'<CR>
noremap <silent> <leader>fL
            \ :execute get(g:, 'fzf_command_prefix', '') . 'Lines'<CR>
noremap <silent> <leader>fM
            \ :execute get(g:, 'fzf_command_prefix', '') . 'Maps'<CR>
noremap <silent> <leader>ft
            \ :execute get(g:, 'fzf_command_prefix', '') . 'BTags'<CR>
noremap <silent> <leader>fT
            \ :execute get(g:, 'fzf_command_prefix', '') . 'Tags'<CR>
" }}}
" vim-easy-align {{{2
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
vmap <Enter> <Plug>(EasyAlign)
" }}}
" vim-cool {{{2
" Show number of matches in the command-line
let g:CoolTotalMatches = 1
" }}}
" vista.vim {{{2
nnoremap <silent> <leader>] :Vista!!<CR>
let g:vista_executive_for = {'pandoc': 'markdown'}
" }}}
" neoformat {{{2
" Enable alignment
let g:neoformat_basic_format_align = 1
" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1
" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
let g:neoformat_enabled_c = ['clangformat', 'uncrustify', 'astyle']
let g:neoformat_enabled_cpp = ['clangformat', 'uncrustify', 'astyle']
" }}}
" lightline {{{2
let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'
let g:lightline.mode_map = {
            \ 'n':      '  ',
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
            \ 'coc_status': 'coc#status',
            \ }
let g:lightline.active = {
            \ 'left': [['mode', 'paste'],
            \          ['coc_status', 'readonly', 'filename', 'modified']]
            \ }
" }}}
" vim-im-select {{{2
" let g:im_select_get_im_cmd = ['macism']
" }}}
" vim-markdown {{{2
let g:markdown_fenced_languages = ['bash', 'vim', 'python', 'json', 'tex']
let g:markdown_conceal_link = 0
autocmd! FileType markdown set concealcursor=nc conceallevel=2
" }}}
" vimtex {{{
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
" }}}
" markdown-preview.nvim {{{2
function! g:OpenUrl(url) abort
    " call system('qutebrowser --target private-window -T -C ~/.config/qutebrowser/config.py ' . a:url)
    " silent exec '!qutebrowser --target private-window -T -C ~/.config/qutebrowser/config.py ' . a:url
    call job_start(['sh', '-c', 'qutebrowser --target private-window -T -C ~/.config/qutebrowser/config.py ' . shellescape(a:url)])
endfunction
let g:mkdp_auto_close = 0
let g:mkdp_browserfunc = 'g:OpenUrl'
nmap <leader>p <Plug>MarkdownPreviewToggle
" }}}
" python-syntax {{{2
let g:python_highlight_all = 1
" }}}
" vim-translator {{{2
let g:translator_history_enable = v:true
let g:translator_default_engines = ['haici', 'youdao']
" Display translation in a window
nmap <silent> <Leader><Space> <Plug>TranslateW
vmap <silent> <Leader><Space> <Plug>TranslateWV
" }}}
" vim-sneak {{{2
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
" netrw (builtin) {{{2
" Disable netrw
" let g:loaded_netrwPlugin = 1
" let g:netrw_liststyle = 1
" Suppress the banner
" let g:netrw_banner = 0
"" Keep the current directory the same as the browsing directory
" let g:netrw_keepdir = 0
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
" let g:netrw_hide = 1
let g:netrw_home = '~/.cache/vim'
" Preview in vertically split window
let g:netrw_preview = 1
" }}}
" syntax/tex.vim (builtin) {{{2
" Set flavor filetype of .tex file
let g:tex_flavor = 'tex'
let g:tex_conceal = 'abmgs'
" }}}
" }}}
" EDITING {{{1
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
" APPEARANCE {{{1
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
set guifont=SauceCodePro\ Nerd\ Font
" [GUI] Hide toolbar
set guioptions-=T

" Setting dark mode
set background=dark
" if strftime('%H') >= 6 && strftime('%H') < 18
"     set background=light
" else
"     set background=dark
" endif
colorscheme gruvbox8

if &background ==# 'dark'
    hi UserRed    guifg=#fb4934 guibg=NONE ctermfg=167 ctermbg=NONE
    hi UserGreen  guifg=#b8bb26 guibg=NONE ctermfg=142 ctermbg=NONE
    hi UserYellow guifg=#fabd2f guibg=NONE ctermfg=214 ctermbg=NONE
    hi UserBlue   guifg=#83a598 guibg=NONE ctermfg=109 ctermbg=NONE
    hi UserPurple guifg=#d3869b guibg=NONE ctermfg=175 ctermbg=NONE
    hi UserAqua   guifg=#8ec07c guibg=NONE ctermfg=108 ctermbg=NONE
    hi UserOrange guifg=#fe8019 guibg=NONE ctermfg=208 ctermbg=NONE
else
    hi UserRed    guifg=#9d0006 guibg=NONE ctermfg=88  ctermbg=NONE
    hi UserGreen  guifg=#79740e guibg=NONE ctermfg=100 ctermbg=NONE
    hi UserYellow guifg=#b57614 guibg=NONE ctermfg=136 ctermbg=NONE
    hi UserBlue   guifg=#076678 guibg=NONE ctermfg=24  ctermbg=NONE
    hi UserPurple guifg=#8f3f71 guibg=NONE ctermfg=96  ctermbg=NONE
    hi UserAqua   guifg=#427b58 guibg=NONE ctermfg=65  ctermbg=NONE
    hi UserOrange guifg=#af3a03 guibg=NONE ctermfg=130 ctermbg=NONE
endif

highlight! link FoldColumn LineNr
highlight! link SignColumn LineNr
highlight link CocErrorSign UserRed
highlight link CocWarningSign UserYellow
highlight link CocInfoSign UserBlue
highlight link CocHintSign UserPurple
" MAPPINGS {{{1
" Personal mapping flavor
" <leader>d* -> daily life
" <leader>f* -> fuzzy finder
" <leader>*  -> frequently used commands
" nnoremap <silent> <leader>q :windo lclose <Bar> cclose <Bar> pclose<CR>
nnoremap <silent> <C-l>     :nohlsearch<CR>
cabbrev W w
cabbrev Q q
cabbrev Qa qa
cabbrev QA qa
cabbrev Wq wq
cabbrev WQ wq
cabbrev Wqa wqa
cabbrev WQa wqa
cabbrev WQA wqa

" Zotero {{{
" Ref: https://retorque.re/zotero-better-bibtex/citing/cayw/
function! ZoteroCite()
  let formats = {
              \ 'markdown': 'formatted-bibliography',
              \ 'pandoc': 'pandoc&brackets=1',
              \ 'tex': 'latex',
              \ }
  let format = get(formats, &filetype, 'formatted-bibliography')
  let api_call = 'http://127.0.0.1:23119/better-bibtex/cayw?format='.format
  let ref = system('curl -s '.shellescape(api_call))
  return ref
endfunction

noremap <leader>z "=ZoteroCite()<CR>p
inoremap <C-z> <C-r>=ZoteroCite()<CR>
" }}}
" }}}
" vim: tw=78 foldenable foldmethod=marker foldcolumn=1
