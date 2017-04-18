scriptencoding utf8

" {{{1 Initialize

" Use space as leader key
nnoremap <space> <nop>
let mapleader = "\<space>"

" -------------------------------------------------------------------------------
" Load plugins
" -------------------------------------------------------------------------------
silent! if plug#begin('~/.vim/bundle')

Plug 'junegunn/vim-plug', { 'on' : [] }

" -------------------------------------------------------------------------------
" My plugins
" -------------------------------------------------------------------------------
Plug '~/.vim/personal'
let s:lervag = index([
      \ 'yoga',
      \ 'vsl136',
      \ 'vsl142',
      \ 'unity.sintef.no',
      \], hostname()) >= 0 ? 'git@github.com:lervag/' : 'lervag/'
call plug#(s:lervag . 'vimtex')
call plug#(s:lervag . 'file-line')
if index(['yoga', 'vsl136'], hostname()) >= 0
  Plug 'git@github.com:lervag/wiki'
endif

" -------------------------------------------------------------------------------
" User interface
" -------------------------------------------------------------------------------
Plug 'altercation/vim-colors-solarized'
Plug 'Yggdroot/indentLine'
Plug 'luochen1990/rainbow'

" -------------------------------------------------------------------------------
" Motions and text objects
" -------------------------------------------------------------------------------
Plug 'wellle/targets.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'machakann/vim-columnmove'

" -------------------------------------------------------------------------------
" Programming and editing
" -------------------------------------------------------------------------------
Plug 'chrisbra/vim-diff-enhanced'
Plug 'dyng/ctrlsf.vim'
Plug 'idanarye/vim-vebugger'
Plug 'gregsexton/gitv', { 'on' : 'Gitv' }
Plug 'junegunn/vim-easy-align'
Plug 'dhruvasagar/vim-table-mode'
Plug 'ludovicchabant/vim-gutentags'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'machakann/vim-sandwich'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'vim-scripts/Conque-GDB', { 'on' : 'ConqueGDB' }
Plug 'junegunn/vader.vim'
Plug 'metakirby5/codi.vim'
if v:version >= 800
  Plug 'w0rp/ale'
endif

" -------------------------------------------------------------------------------
" Completion and snippets
" -------------------------------------------------------------------------------
Plug 'Shougo/neocomplete'
Plug 'Shougo/neco-vim'
Plug 'SirVer/ultisnips'

" -------------------------------------------------------------------------------
" Filetype specific
" -------------------------------------------------------------------------------
Plug 'darvelo/vim-systemd'
Plug 'whatyouhide/vim-tmux-syntax'
Plug 'gregsexton/MatchTag'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'jmcantrell/vim-virtualenv', { 'on' :
      \ [ 'VirtualEnvActivate',
      \   'VirtualEnvDeactivate',
      \   'VirtualEnvList' ] }
Plug 'davidhalter/jedi-vim'
Plug 'vim-ruby/vim-ruby'
Plug 'elzr/vim-json'

" -------------------------------------------------------------------------------
" Utility plugins
" -------------------------------------------------------------------------------
Plug 'moll/vim-bbye', { 'on' : 'Bdelete' }
Plug 'Konfekt/FastFold'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/unite-help'
Plug 'Shougo/unite-outline'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimproc', { 'do' : 'make -f make_unix.mak' }
Plug 'ervandew/screen'
Plug 'itchyny/calendar.vim'
Plug 'mbbill/undotree', { 'on' : 'UndotreeToggle' }
Plug 'nhooyr/neoman.vim'
Plug 'thinca/vim-prettyprint'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-unimpaired'
Plug 'tsukkee/unite-tag'
Plug 'tyru/capture.vim', { 'on' : 'Capture' }
Plug 'KabbAmine/zeavim.vim', {'on': [
      \ 'Zeavim',
      \ 'Docset',
      \ '<Plug>Zeavim',
      \ '<Plug>ZVVisSelection',
      \ '<Plug>ZVKeyDocset',
      \ '<Plug>ZVMotion'
      \]}
Plug 'sunaku/vim-dasht'

call plug#end() | endif

" }}}1
" {{{1 Autocommands

augroup vimrc_autocommands
  autocmd!

  " Only use cursorline for current window
  autocmd WinEnter,FocusGained * setlocal cursorline
  autocmd WinLeave,FocusLost   * setlocal nocursorline

  " When editing a file, always jump to the last known cursor position.  Don't
  " do it when the position is invalid or when inside an event handler (happens
  " when dropping a file on gvim).
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line('$') |
        \   execute 'normal! g`"' |
        \ endif

  " Set omnifunction if it is not already specified
  autocmd Filetype *
        \ if &omnifunc == "" |
        \   setlocal omnifunc=syntaxcomplete#Complete |
        \ endif

  " Set keymapping for command window
  autocmd CmdwinEnter * nnoremap <buffer> q <c-c><c-c>
augroup END

" {{{1 Options

" -------------------------------------------------------------------------------
" Basic
" -------------------------------------------------------------------------------
set history=10000
set cpoptions+=J
set tags=tags;~,.tags;~
set path=.,**
set nrformats-=octal
set fileformat=unix
set wildignore=*.o
set wildignore+=*~
set wildignore+=*.pyc
set wildignore+=.git/*
set wildignore+=.hg/*
set wildignore+=.svn/*
set wildignore+=*.DS_Store
set wildignore+=CVS/*
set wildignore+=*.mod
set diffopt=filler,foldcolumn:0,context:4
if has('gui_running')
  set diffopt+=vertical
else
  set diffopt+=horizontal
endif
if has('patch-7.4.399')
  set cryptmethod=blowfish2
else
  set cryptmethod=blowfish
endif

" -------------------------------------------------------------------------------
" Backup, swap and undofile
" -------------------------------------------------------------------------------
set noswapfile
set nobackup
set undofile
set undolevels=1000
set undoreload=10000
set undodir=$HOME/.vim/undofiles

if !isdirectory(&undodir)
  call mkdir(&undodir)
endif

" -------------------------------------------------------------------------------
" Behaviour
" -------------------------------------------------------------------------------
set autochdir
set autoread
set lazyredraw
set confirm
set hidden
set backspace=indent,eol,start
set shortmess=aoOtT
silent! set shortmess+=cI
set textwidth=79
set nowrap
set linebreak
set comments=n:>
set nojoinspaces
set formatoptions+=ronl1j
set formatlistpat=^\\s*[-*]\\s\\+
set formatlistpat+=\\\|^\\s*(\\(\\d\\+\\\|[a-z]\\))\\s\\+
set formatlistpat+=\\\|^\\s*\\(\\d\\+\\\|[a-z]\\)[:).]\\s\\+
set winaltkeys=no
set mouse=

" -------------------------------------------------------------------------------
" Completion
" -------------------------------------------------------------------------------
set wildmenu
set wildmode=longest:full,full
set wildcharm=<c-z>
set complete+=U,s,k,kspell,d,]
set completeopt=longest,menu,preview

" -------------------------------------------------------------------------------
" Presentation
" -------------------------------------------------------------------------------
set list
set listchars=tab:▸\ ,nbsp:%,trail:\ ,extends:,precedes:
set fillchars=vert:│,fold:\ ,diff:⣿
set matchtime=2
set matchpairs+=<:>
set cursorline
set scrolloff=10
set splitbelow
set splitright
set previewheight=20
set noshowmode
set laststatus=2

if !has('gui_running')
  set visualbell
  set t_vb=
endif

" -------------------------------------------------------------------------------
" Folding
" -------------------------------------------------------------------------------
if &foldmethod ==# ''
  set foldmethod=syntax
endif
set foldlevel=0
set foldcolumn=0
set foldtext=TxtFoldText()

function! TxtFoldText()
  let level = repeat('-', min([v:foldlevel-1,3])) . '+'
  let title = substitute(getline(v:foldstart), '{\{3}\d\?\s*', '', '')
  let title = substitute(title, '^["#! ]\+', '', '')
  return printf('%-4s %-s', level, title)
endfunction

" -------------------------------------------------------------------------------
" Indentation
" -------------------------------------------------------------------------------
set tabstop=2
set softtabstop=2
set shiftwidth=2

set smarttab
set expandtab

set autoindent
set copyindent
set preserveindent
silent! set breakindent

" -------------------------------------------------------------------------------
" Searching and movement
" -------------------------------------------------------------------------------
set nostartofline
set ignorecase
set smartcase
set infercase
set incsearch
set showmatch

set display=lastline
set virtualedit=block

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
elseif executable('ack-grep')
  set grepprg=ack-grep\ --nocolor
endif

" -------------------------------------------------------------------------------
" Spell checking
" -------------------------------------------------------------------------------

set spelllang=en_gb
set spellfile+=~/.vim/spell/mywords.latin1.add
set spellfile+=~/.vim/spell/mywords.utf-8.add

" Add simple switch for spell languages
let g:spell_list = ['nospell', 'en_gb', 'nn', 'nb']
function! LoopSpellLanguage()
  if !exists('b:spell_nr') | let b:spell_nr = 0 | endif
  let b:spell_nr += 1
  if b:spell_nr >= len(g:spell_list) | let b:spell_nr = 0 | endif
  if b:spell_nr == 0
    setlocal nospell
    echo 'Spell off'
  else
    let &l:spelllang = g:spell_list[b:spell_nr]
    setlocal spell
    echo 'Spell language:' g:spell_list[b:spell_nr]
  endif
endfunction
nnoremap <silent> <F6> :<c-u>call LoopSpellLanguage()<cr>

" }}}1
" {{{1 Appearance and UI

set background=light
set winwidth=70

if has('gui_running')
  set lines=50
  set columns=82
  set guifont=Inconsolata-g\ for\ Powerline\ Medium\ 9
  set guioptions=ac
  set guiheadroom=0
else
  if &t_Co == 8 && $TERM !~# '^linux'
    set t_Co=256
  endif

  " Set terminal cursor
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[6 q\<Esc>\e]12;3\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\e]12;14\x7\<Esc>\\"
  else
    let &t_SI = "\e[6 q\e]12;3\x7"
    let &t_EI = "\e[2 q\e]12;14\x7"
    silent !echo -ne "\e[2 q\e]12;14\x7"
    autocmd vimrc_autocommands VimLeave *
          \ silent !echo -ne "\e[2 q\e]112\x7"
  endif
endif

" Set colorscheme and custom colors
autocmd vimrc_autocommands ColorScheme * call personal#custom_colors()
silent! colorscheme solarized

" Set gui cursor
set guicursor=a:block
set guicursor+=n:Cursor
set guicursor+=o-c:iCursor
set guicursor+=v:vCursor
set guicursor+=i-ci-sm:ver30-iCursor
set guicursor+=r-cr:hor20-rCursor
set guicursor+=a:blinkon0

"
" Initialize statusline and tabline
"
call statusline#init()
call statusline#init_tabline()

" {{{1 Mappings

"
" Available for mapping
"
"   Q
"   U
"   ctrl-h
"   ctrl-j
"   ctrl-s
"

" Disable some mappings
noremap  <f1>   <nop>
inoremap <f1>   <nop>
inoremap <esc>  <nop>
nnoremap Q      <nop>

" Some general/standard remappings
inoremap jk     <esc>
nnoremap -      <C-^>
nnoremap Y      y$
nnoremap J      mzJ`z
nnoremap j      gj
nnoremap k      gk
nnoremap dp     dp]c
nnoremap do     do]c
nnoremap '      `
nnoremap <c-e>  <c-^>
nnoremap ZZ     :update<cr>:Bdelete<cr>
nnoremap <c-p>  <c-i>

" Buffer navigation
nnoremap <silent> <c-u> :Bdelete<cr>
nnoremap <silent> gb    :bnext<cr>
nnoremap <silent> gB    :bprevious<cr>

" Utility maps for repeatable quickly change current word
nnoremap c*   *``cgn
nnoremap c#   #``cgN
nnoremap cg* g*``cgn
nnoremap cg# g#``cgN

" Navigate folds
nnoremap          zf zMzvzz
nnoremap <silent> zj :silent! normal! zc<cr>zjzvzz
nnoremap <silent> zk :silent! normal! zc<cr>zkzvzz[z

" Use <c-l> to clear/update all the things
if maparg('<c-l>', 'n') ==# ''
  nnoremap <silent> <c-l>
        \ :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>
endif

" Backspace and return for improved navigation
nnoremap        <bs> <c-o>zvzz
nnoremap <expr> <cr> empty(&buftype) ? '<c-]>zvzz' : '<cr>'

" Shortcuts for some files
nnoremap <leader>ev :e ~/.vim/vimrc<cr>
nnoremap <leader>ez :e ~/.dotfiles/zshrc<cr>
nnoremap <leader>xv :so ~/.vim/vimrc<cr>

" Toggle fontsize
nnoremap <silent> <leader>+ :call personal#toggle_fontsize('+')<cr>
nnoremap <silent> <leader>0 :call personal#toggle_fontsize('0')<cr>

vnoremap <silent><expr> ++ personal#visual_math#yank_and_analyse()
nmap     <silent>       ++ vip++<esc>

" }}}1
" {{{1 Plugin options

" {{{2 vim-internal

runtime macros/matchit.vim

let g:loaded_2html_plugin     = 1
let g:loaded_getscriptPlugin  = 1
let g:loaded_gzip             = 1
let g:loaded_logipat          = 1
let g:loaded_rrhelper         = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tarPlugin        = 1
let g:loaded_vimballPlugin    = 1
let g:loaded_zipPlugin        = 1

let g:python_highlight_all = 1

let g:vimsyn_embed = 'P'

" }}}2

" {{{2 plugin: vim-plug

let g:plug_window = 'tab new'

nnoremap <silent> <leader>pd :PlugDiff<cr>
nnoremap <silent> <leader>pi :PlugInstall<cr>
nnoremap <silent> <leader>pu :PlugUpdate<cr>
nnoremap <silent> <leader>ps :PlugStatus<cr>
nnoremap <silent> <leader>pc :PlugClean<cr>

" }}}2
" {{{2 plugin: indentLine

let g:indentLine_fileType = [
      \ 'sh',
      \ 'vim',
      \ 'fortran',
      \ 'python',
      \]
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#d6d0bf'
let g:indentLine_concealcursor = ''
if has('gui_running')
  let g:indentLine_char = '┊'
else
  let g:indentLine_char = '|'
endif

" }}}2
" {{{2 plugin: rainbow

let g:rainbow_active = 1
let g:rainbow_conf = {
      \ 'guifgs': ['#f92672', '#00afff', '#268bd2', '#93a1a1', '#dc322f',
      \   '#6c71c4', '#b58900', '#657b83', '#d33682', '#719e07', '#2aa198'],
      \ 'ctermfgs': ['9', '127', '4', '1', '3', '12', '5', '2', '6', '33',
      \   '104', '124', '7', '39'],
      \ 'separately' : {
      \   '*' : 0,
      \   'fortran' : {},
      \ }
      \}

" }}}2
" {{{2 plugin: targets.vim

let g:targets_argOpening = '[({[]'
let g:targets_argClosing = '[]})]'
let g:targets_separators = ', . ; : + - = ~ _ * # / | \ &'
let g:targets_nlNL = 'nN  '

" }}}2
" {{{2 plugin: incsearch.vim

let g:incsearch#auto_nohlsearch = 1
let g:incsearch#separate_highlight = 1

set hlsearch
nmap /  <plug>(incsearch-forward)
nmap ?  <plug>(incsearch-backward)
nmap g/ <plug>(incsearch-stay)
nmap n  <plug>(incsearch-nohl-n)zvzz
nmap N  <plug>(incsearch-nohl-N)zvzz
nmap *  <plug>(incsearch-nohl-*)zvzz
nmap #  <plug>(incsearch-nohl-#)zvzz
nmap g* <plug>(incsearch-nohl-g*)zvzz
nmap g# <plug>(incsearch-nohl-g#)zvzz

" }}}2
" {{{2 plugin: vim-columnmove

let g:columnmove_no_default_key_mappings = 1

for s:x in split('ftFT;,wbeWBE', '\zs')
  silent! call columnmove#utility#map('nxo', s:x, '<m-' . s:x . '>', 'block')
endfor
unlet s:x
silent! call columnmove#utility#map('nxo', 'ge', '<m-g>e', 'block')
silent! call columnmove#utility#map('nxo', 'gE', '<m-g>E', 'block')

" }}}2
" {{{2 plugin: vim-diff-enhanced

let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'

" }}}2
" {{{2 plugin: Conque-GDB

" ConqueGDB options
let g:ConqueGdb_Leader = '<leader>d'
let g:ConqueGdb_SrcSplit = 'left'

" ConqueTerm options
let g:ConqueTerm_Color = 2
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_ReadUnfocused = 1

" }}}
" {{{2 plugin: vim-fugitive

nnoremap <leader>gs :Gtogglestatus<cr>
nnoremap <leader>ge :Gedit<cr>
nnoremap <leader>gd :Gdiff<cr>

command! Gtogglestatus :call Gtogglestatus()

function! Gtogglestatus()
  if buflisted(bufname('.git/index'))
    bd .git/index
  else
    Gstatus
  endif
endfunction

augroup vimrc_fugitive
  autocmd!
  autocmd BufReadPost fugitive:// setlocal bufhidden=delete
augroup END

" }}}
" {{{2 plugin: gitv

let g:Gitv_WipeAllOnClose = 1

nnoremap <leader>gl :Gitv --all<cr>
nnoremap <leader>gL :Gitv! --all<cr>
xnoremap <leader>gl :Gitv! --all<cr>

" }}}
" {{{2 plugin: vim-lawrencium

nnoremap <leader>hs :Hgstatus<cr>
nnoremap <leader>hl :Hglog<cr>
nnoremap <leader>hL :Hglogthis<cr>
nnoremap <leader>hd :call MyHgWrapper('Hgvdiff')<cr>
nnoremap <leader>hr :call MyHgWrapper('Hgvrecord')<cr>
nnoremap <leader>ha :call MyHgabort()<cr>

function! MyHgWrapper(com)
  execute a:com
  windo setlocal foldmethod=diff
  normal! gg]c
endfunction

function! MyHgabort()
  if exists(':Hgrecordabort')
    Hgrecordabort
  else
    bdelete lawrencium
  endif
  ResizeSplits
  normal! zx
endfunction

" }}}
" {{{2 plugin: vim-gutentags

let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_file_list_command = {
      \ 'markers': {
      \   '.git': 'git ls-files',
      \   '.hg': 'hg files',
      \ },
      \}

" }}}2
" {{{2 plugin: vim-quickrun

let g:quickrun_config = {}
let g:quickrun_config.vader = { 'command' : './run' }
let g:quickrun_config._ = {
      \ 'outputter/buffer/close_on_empty' : 1
      \ }

nmap <leader>rr <plug>(quickrun)
nmap <leader>ro <plug>(quickrun-op)

nnoremap <leader>rs :call QuickRunSimfex()<cr>

function! QuickRunSimfex()
  let l:exec = '''%c -v '
  if getcwd() =~# '\/tests'
    let l:exec .= '%s'''
  else
    let l:file = fnamemodify('../tests/test_' . expand('%:t'), ':p')
    if !filereadable(l:file)
      echo 'Could not find corresponding test file.'
      return
    endif
    let l:exec .= l:file . ''''
  endif
  execute 'QuickRun -command nosetests2 -exec' l:exec
endfunction

" }}}2
" {{{2 plugin: vim-vebugger

let g:vebugger_leader = '<leader>v'

" }}}
" {{{2 plugin: neocomplete

let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_camel_case = 1
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#enable_auto_close_preview = 1
let g:neocomplete#enable_multibyte_completion = 1

inoremap <expr> <c-l>   neocomplete#complete_common_string()
inoremap <expr> <bs>    neocomplete#smart_close_popup() . "\<bs>"
inoremap <expr> <cr>    pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
inoremap <expr> <tab>   <sid>smart_tab()
inoremap <expr> <s-tab> <sid>smart_tab_reverse()

function! s:smart_tab()
  if neocomplete#complete_common_string() !=# ''
    return neocomplete#complete_common_string()
  elseif pumvisible()
    return "\<c-n>"
  else
    let l:col = col('.') - 1
    if !l:col || getline('.')[l:col - 1]  =~# '\s'
      return "\<tab>"
    else
      return neocomplete#start_manual_complete()
    endif
  endif
endfunction

function! s:smart_tab_reverse()
  if pumvisible()
    return "\<c-p>"
  else
    let l:col = col('.') - 1
    if l:col > 0 && getline('.')[l:col - 1]  =~# '\S'
      return neocomplete#start_manual_complete()
    else
      return ''
    endif
  endif
endfunction

" Define dictionaries if they don't exist
if !exists('s:vimrc_neocomplete_init')
  let g:neocomplete#same_filetypes = {}
  let g:neocomplete#keyword_patterns = {}
  let g:neocomplete#sources#omni#input_patterns = {}
  let g:neocomplete#force_omni_input_patterns = {}
  let s:vimrc_neocomplete_init = 1
endif

" Always use completions from all buffers
let g:neocomplete#same_filetypes._ = '_'

" Define keyword patterns
let s:neocomplete_keyword = '[a-zA-ZæÆøØåÅ][0-9a-zA-ZæÆøØåÅ]\+'
let g:neocomplete#keyword_patterns._   = s:neocomplete_keyword
let g:neocomplete#keyword_patterns.tex = '\%(^\|\s\zs\)' . s:neocomplete_keyword

" Define omni input patterns
let g:neocomplete#sources#omni#input_patterns.wiki = '\[\[[^]|]*\|\]([^)]*'
let g:neocomplete#sources#omni#input_patterns.tex =
      \ '\v\\%('
      \ . '\a*cite\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|\a*ref%(\s*\{[^}]*|range\s*\{[^,}]*%(}\{)?)'
      \ . '|hyperref\s*\[[^]]*'
      \ . '|includegraphics\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|%(include%(only)?|input)\s*\{[^}]*'
      \ . '|usepackage%(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|documentclass%(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|\a*'
      \ . ')'

" Define omni force patterns
let g:neocomplete#force_omni_input_patterns.wiki = '\[\[[^]|]*#\S*'

" {{{2 plugin: UltiSnips

let g:neosnippet#snippets_directory = '~/.vim/snippets'

let g:UltiSnipsExpandTrigger = '<c-j>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsSnippetDirectories = [$HOME . '/.vim/UltiSnips']

nnoremap <leader>es :UltiSnipsEdit!<cr>

" }}}2
" {{{2 plugin: vimtex (LaTeX)

let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_index_split_pos = 'below'
let g:vimtex_fold_enabled = 1
let g:vimtex_format_enabled = 1
let g:vimtex_view_method = 'zathura'
let g:vimtex_imaps_leader = ';'
let g:vimtex_complete_img_use_tail = 1
let g:vimtex_view_automatic = 0

nnoremap \lt :Unite vimtex_toc<cr>

let g:tex_stylish = 1
let g:tex_conceal = ''
let g:tex_flavor = 'latex'
let g:tex_isk='48-57,a-z,A-Z,192-255,:'

"
" NOTE: See also ~/.vim/personal/ftplugin/tex.vim
"

" }}}2
" {{{2 plugin: vim-pandoc

let g:pandoc#folding#level = 9
let g:pandoc#folding#fdc = 0
let g:pandoc#formatting#mode = 'h'
let g:pandoc#toc#position = 'top'
let g:pandoc#modules#disabled = ['spell']

nnoremap <silent><leader>rp :Pandoc! #sintefpres<cr>

" }}}2
" {{{2 plugin: jedi-vim

let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#rename_command = ''

" }}}2
" {{{2 plugin: vim-ruby

let g:ruby_fold=1

" }}}2
" {{{2 plugin: wiki

let g:wiki = { 'root' : '~/documents/wiki' }

" }}}2
" {{{2 plugin: calendar.vim

let g:calendar_first_day = 'monday'
let g:calendar_date_endian = 'big'
let g:calendar_frame = 'space'
let g:calendar_week_number = 1

nnoremap <silent> <leader>c :Calendar -position=here<cr>

" Connect to diary
augroup vimrc_calendar
  autocmd!
  autocmd FileType calendar
        \ nnoremap <silent><buffer> <cr> :<c-u>call OpenDiary()<cr>
augroup END
function! OpenDiary()
  let l:date = printf('%d-%0.2d-%0.2d',
        \ b:calendar.day().get_year(),
        \ b:calendar.day().get_month(),
        \ b:calendar.day().get_day())
  let l:bufnr = bufnr('')

  enew
  execute 'bwipeout!' l:bufnr
  call wiki#journal#make_note(l:date)
endfunction

" }}}2
" {{{2 plugin: CtrlFS

let g:ctrlsf_indent = 2
let g:ctrlsf_regex_pattern = 1
let g:ctrlsf_position = 'bottom'
let g:ctrlsf_context = '-B 2'
let g:ctrlsf_default_root = 'project+fw'
let g:ctrlsf_populate_qflist = 1
if executable('rg')
  let g:ctrlsf_ackprg = 'rg'
endif

nnoremap         <leader>ff :CtrlSF 
nnoremap <silent><leader>ft :CtrlSFToggle<cr>
nnoremap <silent><leader>fu :CtrlSFUpdate<cr>
vmap     <silent><leader>f  <Plug>CtrlSFVwordExec

" }}}2
" {{{2 plugin: FastFold

nmap <sid>(DisableFastFoldUpdate) <plug>(FastFoldUpdate)
let g:fastfold_fold_command_suffixes =  ['x','X']
let g:fastfold_fold_movement_commands = []

" }}}2
" {{{2 plugin: unite.vim

"
" General settings
"
let g:unite_force_overwrite_statusline=0
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts
        \ = '--nocolor --line-numbers --nogroup -S -C4'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack-grep')
  let g:unite_source_grep_command = 'ack'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -C4'
  let g:unite_source_grep_recursive_opt = ''
endif

"
" Set default context options
"
call unite#custom#profile('default', 'context', {
      \ 'start_insert' : 1,
      \ 'no_split' : 1,
      \ 'prompt' : '> ',
      \ })

"
" Neomru settings
"
call unite#custom#source('file_mru', 'ignore_pattern',
      \ '\v' . join([
      \   '\/\.%(git|hg)\/',
      \   '\.wiki$',
      \   '\.snip$',
      \   '\.vim\/vimrc$',
      \   '\/vim\/.*\/doc\/.*txt$',
      \   '_%(LOCAL|REMOTE)_',
      \   '\~record$',
      \   '^\/tmp\/',
      \   '^man:\/\/',
      \   ], '|'))

"
" Other settings
"
call unite#custom#source('file,file_mru', 'converters', 'converter_mypath')
call unite#custom#source('file,file_rec,file_rec/async', 'ignore_pattern',
      \ '\v' . join([
      \   '\/undofiles\/',
      \ ], '|'))

"
" Mappings
"
nnoremap <silent> <leader><leader> :<c-u>Unite file_mru <cr>
nnoremap <silent> <leader>oo       :<c-u>Unite file<cr>
nnoremap <silent> <leader>ob       :<c-u>Unite buffer<cr>
nnoremap <silent> <leader>oh       :<c-u>Unite help<cr>
nnoremap <silent> <leader>ot       :<c-u>Unite outline tag tag/include<cr>
nnoremap <silent> <leader>om       :<c-u>Unite mapping<cr>
nnoremap <silent> <leader>oc       :<c-u>Unite command<cr>
nnoremap <silent> <leader>ow       :<c-u>Unite wiki<cr>
nnoremap <silent> <leader>ov       :<c-u>Unite file_rec/async:~/.vim<cr>

"
" Mappings and similar inside Unite buffers
"
function! s:unite_settings()
  nmap <buffer> q     <plug>(unite_exit)
  nmap <buffer> Q     <plug>(unite_exit)
  nmap <buffer> <esc> <plug>(unite_exit)
  imap <buffer> <esc> <plug>(unite_exit)
  imap <buffer> <c-j> <plug>(unite_select_next_line)
  imap <buffer> <c-k> <plug>(unite_select_previous_line)
  imap <buffer> <f5>  <plug>(unite_redraw)
  nmap <buffer> <f5>  <plug>(unite_redraw)
endfunction
augroup vimrc_unite
  autocmd!
  autocmd FileType unite call s:unite_settings()
augroup END

" }}}2
" {{{2 plugin: screen

let g:ScreenImpl = 'Tmux'
let g:ScreenShellTmuxInitArgs = '-2'
let g:ScreenShellTerminal = 'urxvt'
let g:ScreenShellActive = 0

" Dynamic keybindings
function! s:ScreenShellListenerMain()
  if g:ScreenShellActive
    nnoremap <silent> <c-c><c-c> <s-v>:ScreenSend<cr>
    vnoremap <silent> <c-c><c-c> :ScreenSend<cr>
    nnoremap <silent> <c-c><c-a> :ScreenSend<cr>
    nnoremap <silent> <c-c><c-q> :ScreenQuit<cr>
    if exists(':C') != 2
      command -nargs=? C :call ScreenShellSend('<args>')
    endif
  else
    nnoremap <c-c><c-a> <nop>
    vnoremap <c-c><c-c> <nop>
    nnoremap <c-c><c-q> <nop>
    nnoremap <silent> <c-c><c-c> :ScreenShell<cr>
    if exists(':C') == 2
      delcommand C
    endif
  endif
endfunction

" Initialize and define auto group stuff
nnoremap <silent> <c-c><c-c> :ScreenShell<cr>
augroup ScreenShellEnter
  autocmd User * :call <sid>ScreenShellListenerMain()
augroup END
augroup ScreenShellExit
  autocmd User * :call <sid>ScreenShellListenerMain()
augroup END

" }}}2
" {{{2 plugin: undotree

let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

nnoremap <f5> :UndotreeToggle<cr>

" }}}2
" {{{2 plugin: vim-easy-align

let g:easy_align_bypass_fold = 1

nmap ga <plug>(LiveEasyAlign)
vmap ga <plug>(LiveEasyAlign)
nmap gA <plug>(EasyAlign)
vmap gA <plug>(EasyAlign)
vmap .  <plug>(EasyAlignRepeat)

" }}}2
" {{{2 plugin: vim-table-mode


" }}}2
" {{{2 plugin: vim-sandwich

let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1
let g:textobj_sandwich_no_default_key_mappings = 1

" Surround mappings (similar to surround.vim)
nmap gs  <plug>(operator-sandwich-add)
nmap gss <plug>(operator-sandwich-add)iW
nmap ds  <plug>(operator-sandwich-delete)<plug>(textobj-sandwich-query-a)
nmap dss <plug>(operator-sandwich-delete)<plug>(textobj-sandwich-auto-a)
nmap cs  <plug>(operator-sandwich-replace)<plug>(textobj-sandwich-query-a)
nmap css <plug>(operator-sandwich-replace)<plug>(textobj-sandwich-auto-a)
xmap sa  <plug>(operator-sandwich-add)
xmap sd  <plug>(operator-sandwich-delete)
xmap sr  <plug>(operator-sandwich-replace)

" Text objects
xmap is  <plug>(textobj-sandwich-query-i)
xmap as  <plug>(textobj-sandwich-query-a)
omap is  <plug>(textobj-sandwich-query-i)
omap as  <plug>(textobj-sandwich-query-a)
xmap iss <plug>(textobj-sandwich-auto-i)
xmap ass <plug>(textobj-sandwich-auto-a)
omap iss <plug>(textobj-sandwich-auto-i)
omap ass <plug>(textobj-sandwich-auto-a)

" Change some default options
silent! call operator#sandwich#set('delete', 'all', 'highlight', 0)
silent! call operator#sandwich#set('all', 'all', 'cursor', 'keep')

" Allow repeats while keeping cursor fixed
silent! runtime autoload/repeat.vim
nmap . <plug>(operator-sandwich-predot)<plug>(RepeatDot)

" Default recipes
let g:sandwich#recipes  = deepcopy(g:sandwich#default_recipes)
let g:sandwich#recipes += [
      \ {
      \   'buns' : ['{\s*', '\s*}'],
      \   'input' : ['}'],
      \   'kind' : ['delete', 'replace', 'auto', 'query'],
      \   'regex' : 1,
      \   'nesting' : 1,
      \   'match_syntax' : 1,
      \   'skip_break' : 1,
      \   'indentkeys-' : '{,},0{,0}'
      \ },
      \ {
      \   'buns' : ['\[\s*', '\s*\]'],
      \   'input' : [']'],
      \   'kind' : ['delete', 'replace', 'auto', 'query'],
      \   'regex' : 1,
      \   'nesting' : 1,
      \   'match_syntax' : 1,
      \   'indentkeys-' : '[,]'
      \ },
      \ {
      \   'buns' : ['(\s*', '\s*)'],
      \   'input' : [')'],
      \   'kind' : ['delete', 'replace', 'auto', 'query'],
      \   'regex' : 1,
      \   'nesting' : 1,
      \   'match_syntax' : 1,
      \   'indentkeys-' : '(,)'
      \ },
      \]

" }}}2
" {{{2 plugin: vim-json

let g:vim_json_syntax_conceal = 0

" }}}2
" {{{2 plugin: codi

nnoremap <leader>ii :Codi!!<cr>
nnoremap <leader>ip :Codi python<cr>

augroup vimrc_codi
  autocmd!
  autocmd User CodiEnterPost
        \ set columns-=50
        \|hi VertSplit guifg=bg guibg=NONE
        \|hi NonText guifg=bg guibg=NONE
  autocmd User CodiLeavePost
        \ hi clear VertSplit
        \|hi clear NonText
augroup END

" }}}2
" {{{2 plugin: ale

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'

let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'

let g:ale_statusline_format = ['Errors: %d', 'Warnings: %d', '']

let g:ale_linters = {
      \ 'tex': [],
      \}

nmap <silent> <leader>j <Plug>(ale_next_wrap)
nmap <silent> <leader>k <Plug>(ale_previous_wrap)

" }}}2
" {{{2 plugin: zeavim

let g:zv_disable_mapping = 1
let g:zv_keep_focus = 0
let g:zv_zeal_args = '--style=gtk+'
let g:zv_file_types = {
    \ 'help' : 'vim',
    \ 'python' : 'python 3',
    \ }

nmap gzz <plug>Zeavim
xmap gzz <plug>ZVVisSelection
nmap gz <plug>ZVMotion

" }}}2

" }}}1

" vim: fdm=marker
