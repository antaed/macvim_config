" GENERAL SETUP ------------------------------------------------

let g:lightline = { 'colorscheme': 'antaed_light', 'mode_map': { 'n': '  N', 'c': '  C', 'i': '  I', 'v':'  V', 'V': ' VL', "\<C-v>": ' VB', 'R': '  R', '?': '   ' },
            \ 'active':   { 'left': [ [ 'mode' ], [ 'modified', 'readonly' ], [ 'filename' ], [ 'cocerror' ], [ 'cocwarn' ], [ 'cochint' ], [ 'cocinfo' ] ] }, 
            \ 'inactive': { 'left': [ [ 'mode' ], [ 'modified' ], [ 'filename' ] ] }, 'subseparator': { 'left': '', 'right':'' }, 
            \ 'component_function': { 'modified': 'CustomModified' },
            \ 'component_expand': {
                    \ 'cocerror': 'LightLineCocError',
                    \ 'cocwarn' : 'LightLineCocWarn',
                    \ 'cochint' : 'LightLineCocHint',
                    \ 'cocinfo' : 'LightLineCocInfo' },
            \ }
function! CustomModified()
    return &modified ? '+' : ''
endfunction

" sync colorscheme
augroup lightline-events
    autocmd!
    autocmd ColorScheme * call s:onColorSchemeChange(expand("<amatch>"))
    autocmd User CocDiagnosticChange call lightline#update()
augroup END
let s:colour_scheme_map = {'antaed_light': 'antaed'}
function! s:onColorSchemeChange(scheme)
    " Try a scheme provided already
    execute 'runtime autoload/lightline/colorscheme/'.a:scheme.'.vim'
    if exists('g:lightline#colorscheme#{a:scheme}#palette')
        let g:lightline.colorscheme = a:scheme
    else  " Try falling back to a known colour scheme
        let l:colors_name = get(s:colour_scheme_map, a:scheme, '')
        if empty(l:colors_name)
            return
        else
            let g:lightline.colorscheme = l:colors_name
        endif
    endif
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
endfunction

" custom coc-diagnose highlights
function! s:LightlineCodDiagnostics(sign, kind) abort
    let g:lightline.component_type = {
                \   'cocerror': 'error',
                \   'cocwarn' : 'warning',
                \   'cochint' : 'hints',
                \   'cocinfo' : 'info',
                \ }
  let css = { 'E:': 'coc_status_error_sign', 'W:': 'coc_status_warning_sign', 'H:': 'coc_status_hint_sign', 'I:': 'coc_status_info_sign' }
  let sign = get(g:, css[a:sign], a:sign)
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info)
    return ''
  endif
  let msgs = []
  if get(info, a:kind, 0)
    call add(msgs, sign . info[a:kind])
  endif
  return trim(join(msgs, ' ') . ' ' . get(g:, 'coc_status', ''))
endfunction
function! LightLineCocError() abort
    return s:LightlineCodDiagnostics('E:','error')
endfunction
function! LightLineCocWarn() abort
    return s:LightlineCodDiagnostics('W:','warning')
endfunction
function! LightLineCocHint() abort
    return s:LightlineCodDiagnostics('H:','hint')
endfunction
function! LightLineCocInfo() abort
    return s:LightlineCodDiagnostics('I:','info')
endfunction

" toggle colorscheme with goyo
" function! s:goyo_enter()
"     colorscheme antaed_light
"     silent! call lightline#disable()
" endfunction
" function! s:goyo_leave()
"     colorscheme antaed
" endfunction
" autocmd! User GoyoEnter nested call <SID>goyo_enter()
" autocmd! User GoyoLeave nested call <SID>goyo_leave()

set laststatus=2
runtime macros/matchit.vim

set guifont=M+\ 1mn\ light:h13

colorscheme antaed_light

if !exists("g:syntax_on")
    syntax enable
endif

" Defaults
set guioptions=
set backup
set backupdir=$HOME/.backups/.backup//
set swapfile
set directory=$HOME/.backups/.swp//
set undofile
set undodir=$HOME/.backups/.undo//
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab breakindent autoindent
set relativenumber number
set ignorecase smartcase
set wildmenu showmatch
set incsearch hlsearch
set selectmode-=mouse " Disable mouse select mode
set encoding=utf-8
set diffopt=filler,foldcolumn:0,context:0
set notimeout ttimeout timeoutlen=100 " prevent esc key mapping clashes in terminal
scriptencoding utf-8
set redrawtime=10000
set updatetime=750
set wildignore+=*/.git/*,*/tmp/*,*.swp
filetype plugin indent on

" Netrw configuration
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

" Autocommands
" autocmd FileType php set omnifunc=phpcomplete#CompletePHP
" autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd TerminalOpen * if &buftype == 'terminal' | setlocal bufhidden=hide | endif
autocmd GUIEnter * set vb t_vb= " Disable bell

" Set default woring directory
tcd Downloads/



" KEY REMAPS ----------------------------------------------------------

" Remap leader
map <Space> <Leader>

" Open vimrc in new tab
nmap <leader>g :tabedit $HOME/.vim/gvimrc<CR>

" Source gvimrc
nmap <leader>sg :source $MYGVIMRC<CR>

" Correct pasting
nnoremap <leader>p p`[v`]=

" Copy and paste highlighted word
macmenu Edit.Copy<Tab>"+y key=<nop>
vnoremap <D-c> "+y
macmenu Edit.Paste<Tab>"+gP key=<nop>
vnoremap <D-v> "+gP
if (&hls && v:hlsearch)
    nnoremap <D-c> "+yiw
    nnoremap <D-v> ciw<C-r><C-o>+<esc>
endif

" Search highlights off
nnoremap <silent> <leader><space> :call popup_clear() <bar> :nohl<cr>

" Remap buffer motion
nnoremap <D-Down> :bnext<CR>
nnoremap <D-Up> :bprevious<CR>
nnoremap <D-Left> :tabprevious<CR>
nnoremap <D-Right> :tabnext<CR>

" Remap Cmd-a
nnoremap <D-a> ggVG

" Switch windows
map <M-Down>  <C-W>j
map <M-Up>    <C-W>k
map <M-Left>  <C-W>h
map <M-Right> <C-W>l

" Move windows
map <S-Down>  <C-W>J
map <S-Up>    <C-W>K
map <S-Left>  <C-W>H
map <S-Right> <C-W>L

" Ease movement
nnoremap <silent> <C-j> :move+<CR>==
nnoremap <silent> <C-k> :move-2<CR>==
nnoremap <C-h> <<
nnoremap <C-l> >>
xnoremap <silent> <C-j> :move'>+<CR>gv=gv
xnoremap <silent> <C-k> :move-2<CR>gv=gv
xnoremap <C-h> <gv
xnoremap <C-l> >gv
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>

"Duplicate lines above and below
xnoremap <leader>j YPgv
nnoremap <leader>j Yp
xnoremap <leader>k Y`>pgv
nnoremap <leader>k YP

" jump to next/previous code block
nnoremap <silent> ∆ /\W<\zs\w\\|[([{]\zs.\\|<?php\s\zs\w<cr>:noh<cr>
nnoremap <silent> ˚ ?\(\W<\)\@<=\w\\|\([([{]\)\@<=.\\|\(<\?php\s\)\@<=\w<cr>:noh<cr>
inoremap <silent> ∆ <esc>l/\W<\zs\w\\|[([{]\zs.\\|<?php\s\zs\w<cr>:noh<cr>i
inoremap <silent> ˚ <esc>?\(\W<\)\@<=\w\\|\([([{]\)\@<=.\\|\(<\?php\s\)\@<=\w<cr>:noh<cr>i

" Jump to next/previous target
nnoremap <silent> ¬ /\w\+<cr>:noh<cr>h 
nnoremap <silent> ˙ ?\w\+<cr>:noh<cr>h 
inoremap <silent> ¬ <esc>l/\w\+<cr>:noh<cr>ea
inoremap <silent> ˙ <esc>?\w\+<cr>n:noh<cr>ea

"Will open files in current directory, allows you to leave the working cd in the project root. You can also use %% anywhere in the command line to expand.
cnoremap %% <C-R>=expand('%:h').'/'<cr>
nmap <leader>ew :e %%
nmap <leader>es :sp %%
nmap <leader>ev :vsp %%
nmap <leader>et :tabe %%

" Reselect pasted block
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Open vertical split and switch to it
nnoremap <leader>w <C-w>v<C-w>l

" Autocomplete remaps
" Go back in insert mode
inoremap <expr> <C-h> pumvisible() ? "\<esc>a" : "\<esc>i"
" Go forward in insert mode
inoremap <expr> <C-l> pumvisible() ? "\<esc>a" : "\<esc>la"
" Delete to beginning of the line
inoremap <expr> <C-BS> pumvisible() ? "\<esc>a" : "\<C-u>"

" Replace word under cursor | within visual selection
nnoremap <leader>\ :%s/\<<C-r><C-w>\>/
vnoremap <leader>\ :s/\%V

" Shrink/Enlarge selection
vnoremap ∆ ojo
vnoremap ˙ ok1o
vnoremap ˚ k$
vnoremap ¬ j$

" Delete all but PHP / Delete all PHP
vnoremap <silent> <leader>dh J0/<?php.\{-}?><cr><esc>:call ClearAllButMatches()<cr>:noh<cr>
vnoremap <silent> <leader>dp :s/\%V<?php.\{-}?>/string/g<cr>

" Vim-Session plugin remaps
nnoremap <silent> <F9> :packadd vim-misc <bar> :packadd vim-session <bar> :echom "Vim-Sessions added"<cr>
nnoremap <leader>so :OpenSession
nnoremap <leader>ss :SaveSession
nnoremap <leader>sd :DeleteSession<CR>
nnoremap <leader>sc :CloseSession<CR>

" Delete multiple spaces between tags
nnoremap <silent> <leader>ds vat :s/\%V\(\s\+\ze<\\|>\zs\s\+\)//g <bar> :noh<cr>gv=
vnoremap <silent> <leader>ds :s/\%V\(\s\+\ze<\\|>\zs\s\+\)//g <bar> :noh<cr>gv=

" Clear trailing spaces
nnoremap <silent> <leader>cs :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" Clear empty liness
nnoremap <silent> <leader>de vat :g/^\s*$/d <bar> :noh<cr>
vnoremap <silent> <leader>de :g/^\s*$/d <bar> :noh<cr>

" Split tags/braces into separate lines
nnoremap <silent> † cit<esc>O<esc>p==
nnoremap <silent> ∫ /[([{]<cr>v%<esc>i<esc>`<a<esc>:noh<cr>
autocmd FileType php  nnoremap <silent> π 0f{V%<esc>?<?<cr>hv`</?><cr>llc<esc>:noh<cr>O<esc>p==

" Renamer
nmap <Leader>r <Plug>RenamerStart

" Improved line/selection Surround
nmap <silent> ∑ ysstdiv.<CR>F"i
vmap <silent> ∑ V<esc>gvStdiv.<CR>vat=?""<CR>a

" Delete spaces between tags when joining lines
autocmd FileType php,html noremap <silent> J J^v$:s/\%V\(\s\+\ze<\\|>\zs\s\+\)//g <bar> :noh<cr>$

" Comment inside php tags
noremap <leader>ci :s/<?php[\n\r\s]*\zs\(.\{-}\)\ze[\n\r\s]*?>/\/*\1*\//g <bar> :noh<cr>
vnoremap <leader>ci :s/\%V<?php[\n\r\s]*\zs\(.\{-}\)\ze[\n\r\s]*?>/\/*\1*\//g <bar> :noh<cr>

" Delete comments inside php tags
noremap <leader>cci :s/\/\*\\|\*\///g <bar> :noh<cr>
vnoremap <leader>cci :s/\%V\/\*\\|\*\///g <bar> :noh<cr>

" Activate HiLinkTrace
nnoremap <silent> <leader>synt :packadd vim-HiLinkTrace<cr>:HLT!<cr>

" Increment numbers
noremap <A-x> <C-A>

" Load unicode.vim
nnoremap <silent> <leader>dig :packadd unicode.vim<cr>

" Increment multiple lines by one
vnoremap <leader>+ 1g<C-a>

" Multiply html tag
nnoremap <leader>t vatYgv<esc>jP

" Multiply curly brackets surrounded
nnoremap <leader>b va{Ygv<esc>jP

" Refresh browser
nnoremap <leader>u :RRB<cr>

" Jump to indented new line from within brackets
imap <C-cr> <cr><cr><esc>ki<C-t> 
imap <expr> <CR> delimitMate#WithinEmptyPair() ? "\<Plug>delimitMateCR" : "\<cr>"

" Duplicate current buffer in the same directory
nnoremap <leader>df :sav! %:h/

" Improved line/selection comment Surround
nnoremap <leader>ca V%<esc>`<O<?php /*<esc>`>o*/ ?><esc>
nnoremap <leader>cca 0f*V%<esc>`<dd`>dd
vnoremap <leader>ca <esc>`<O<?php /*<esc>`>o*/ ?><esc>
vnoremap <leader>cca <esc>`<dd`>dd

" Delete surrounding php braces
nnoremap <leader>db va{V<esc>?<?<CR>?\S<cr>d`>`<^d/?><cr>xd/\S<cr>:noh<cr>

" Select all/inside php braces
" nnoremap <leader>vab va{V
" nnoremap <leader>vib va{<esc>?<?<CR>?\S<cr>mk`</?><cr>l/\S<cr>:noh<cr>v`k

" wysiwyg formatting
nnoremap <silent> <leader>fs cit<span style="font-size:12px">"</span><esc>
nnoremap <silent> <leader>cn :%s/\(&nbsp;\)\+/ /g<cr>:g/<p>\s\+<\/p>/normal! dd<cr>
vnoremap <silent> <leader>ul :s/\%V<\/\{-}\zsp\ze>/li/g<cr>gv<esc>o</ul><esc>'<O<ul><esc>vat=
nnoremap <silent> <leader>bb 0i<tr><td class="bold"><esc>Ea</td><td>A</td></tr><esc>j
nnoremap <silent> <leader>lr 0cf><div class="row"><div class="col-50"><esc>/\s\{3,}<cr>cw</div><div class="col-50 text-right"><esc>/<\/<cr>C</div></div><esc>:noh<cr>
vnoremap <silent> <leader>trd Vc<tr>"</tr><esc>vit:s#\%V\zs\S.*\ze$#<td class="numeric-cell">&</td>#e<cr>:noh<cr>
vnoremap <silent> <leader>trh Vc<tr>"</tr><esc>vit:s#\%V\zs\S.*\ze$#<th class="numeric-cell">&</th>#e<cr>:noh<cr>
nnoremap <silent> <leader>td ^c$<td class="numeric-cell">"</td><esc>
nnoremap <silent> <leader>th ^c$<th class="numeric-cell">"</th><esc>
vnoremap <silent> <leader>sup c<sup>"</sup><esc>
vnoremap <silent> <leader>sub c<sub>"</sub><esc>

" Load vCoolor
nnoremap <silent> <leader>col :packadd vCoolor.vim<cr>

" Diff controls
nnoremap <leader>vd :windo diffthis<CR>
nnoremap <expr> <S-h> &diff ? '<ScrollWheelLeft>' : 'H'
nnoremap <expr> <S-l> &diff ? '<ScrollWheelRight>' : 'L'
nnoremap <expr> du &diff ? ':diffupdate' : ''
nnoremap <expr> dj &diff ? ']c' : ''
nnoremap <expr> dk &diff ? '[c' : ''

" Terminal mappings
tnoremap <esc> <C-w>N
tnoremap <F3> <C-w><C-c>
nnoremap <F3> i<C-w><C-c>
"
" Jump to next error
nmap <silent> <F4> <Plug>(coc-diagnostic-next-error)
nmap <silent> <S-F4> <Plug>(coc-diagnostic-prev-error)

" Compare current buffer against the file
nnoremap <silent> <expr> <F5> &diff ? ':windo diffoff:bd' : ":DiffSaved\<CR>"

" HL on double click
nnoremap <silent> <2-LeftMouse> :let @/='\V\<'.escape(expand('<cword>'), '\').'\>' <bar> :set hls<cr>

" CtrlP word under cursor
nmap <F7> :CtrlP<CR><C-\>w
vmap <F7> y:CtrlP<CR><C-\>c

" Switch projects
nnoremap <F2> :call SetProject(3)<CR>
nnoremap <M-F2> :call SetProject(1)<CR>
nnoremap <S-F2> :call SetProject(0)<CR>
nnoremap <silent> <S-M-F2> :tabedit /Volumes/cbmssoftware/www/erp2/index.php<CR>/Andi<CR>:nohl<CR>2T'

" Get PHP Variables
nnoremap <leader>pv /\$\w\+<CR>:CopyMatches<CR>:vnew<CR>:vertical resize 80<CR>"+p:sort u<CR>:nohl<CR>dd
vnoremap <leader>pv <esc>/\%V\$\w\+<CR>:CopyMatches<CR>:vnew<CR>:vertical resize 80<CR>"+p:sort u<CR>:nohl<CR>dd

" Activate Goyo
nnoremap <silent> <expr> <F6> exists('#goyo') ? ":Goyo!\<cr>" : ":packadd goyo.vim \<bar> :Goyo\<cr>"

" Toggle colorscheme
nnoremap <silent> <expr> <F10> g:colors_name=='antaed' ? ":colorscheme antaed_light".( exists('#goyo') ? "\<bar> :silent! call lightline#disable()" : "" )." \<bar> :set guifont=M+\\ 1mn\\ light:h13\<cr>" : ":colorscheme antaed".( exists('#goyo') ? "\<bar> :silent! call lightline#disable()" : "" )." \<bar> :set guifont=M+\\ 1mn\\ light:h13\<cr>"




" PLUGINS --------------------------------------------------------------------

packadd minpac
call minpac#init()
" Minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

" Add other plugins here.
function! s:coc_cb(hooktype, name) abort
    let g:coc_global_extensions = [ 'coc-css', 'coc-html', 'coc-json', 'coc-tsserver', 'coc-phpls' ]
    execute 'packadd ' . a:name
    call coc#util#install()
    call coc#util#install_extension(g:coc_global_extensions)
endfunction
call minpac#add('neoclide/coc.nvim', {'do': function('s:coc_cb')})
call minpac#add('tpope/vim-vinegar')
call minpac#add('ctrlpvim/ctrlp.vim')
call minpac#add('itchyny/lightline.vim')
call minpac#add('marcweber/vim-addon-mw-utils')
call minpac#add('tomtom/tlib_vim')
call minpac#add('honza/vim-snippets')
call minpac#add('garbas/vim-snipmate')
call minpac#add('godlygeek/tabular')
call minpac#add('Raimondi/delimitMate')
call minpac#add('vim-scripts/CSSMinister')
call minpac#add('tomtom/tcomment_vim')
call minpac#add('jremmen/vim-ripgrep')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('ludovicchabant/vim-gutentags')
call minpac#add('captbaritone/better-indent-support-for-php-with-html')
call minpac#add('coderifous/textobj-word-column.vim')
call minpac#add('qpkorr/vim-renamer')
" call minpac#add('junegunn/vim-slash')
call minpac#add('tpope/vim-abolish')
call minpac#add('whiteinge/diffconflicts')
call minpac#add('rrethy/vim-hexokinase', { 'do': 'make hexokinase' })
call minpac#add('machakann/vim-sandwich')
call minpac#add('stefandtw/quickfix-reflector.vim')
call minpac#add('StanAngeloff/php.vim')
call minpac#add('xolox/vim-session', {'type': 'opt'})
call minpac#add('xolox/vim-misc', {'type': 'opt'})
call minpac#add('gerw/vim-HiLinkTrace', {'type': 'opt'})
call minpac#add('KabbAmine/vCoolor.vim', {'type': 'opt'})
call minpac#add('chrisbra/unicode.vim', {'type': 'opt'})
call minpac#add('junegunn/goyo.vim', {'type': 'opt'})
" MacOS only
call minpac#add('mkitt/browser-refresh.vim')

" Load the plugins right now. (optional)
"packloadall"

" Set ctrlp working directory to cwd
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_max_files=0
let g:ctrlp_max_depth=40
" :help ctrlp-commands-extensions
" let g:ctrlp_extensions = ['dir', 'bookmarkdir']

" Use ctrlp with ripgrep
if executable('rg')
  let g:ctrlp_user_command = {
    \ 'types': { 1: ['.git', 'cd %s && git ls-files --exclude-from=ctrlpignore -i'] },
    \ 'fallback': 'rg --files %s --color=never -g "!*.min.*" -g "!*.{map,jpeg,jpg,png,gif,ico,svg,eot,ttf,woff,woff2,otf,pdf,sql,gz,zip,mp4,ogg}" -g "!**/{db,docs,fonts,images,attachments,cache,ean13,plugins,vendor,xlsx_examples,video,*backup*,*old*}/*" -g "!**/{css,js}/**/"' }
  let g:ctrlp_use_caching = 0
  let g:ctrlp_switch_buffer = 'et'
  set grepprg=rg\ --color=never
endif
" Open multiple files
let g:ctrlp_open_multiple_files = 'i'
" custom prompt mappings
let g:ctrlp_prompt_mappings = {
    \ 'ToggleType(1)': ['<c-b>', '<c-down>', '<c-h>'],
    \ 'ToggleType(-1)': ['<c-f>', '<c-up>', '<c-l>'],
    \ 'PrtCurLeft()': ['<left>', '<c-^>'],
    \ 'PrtCurRight()':['<right>'],
\}
" custom status line
let g:ctrlp_status_func = {
    \ 'main': 'CtrlP_Statusline_1',
    \ 'prog': 'CtrlP_Statusline_2',
    \ }
function! CtrlP_Statusline_1(...)
    let prev = '  %#StatusLine#<%*'
    let item = '%#Search# '.toupper(a:5).' %*'
    let next = '%#StatusLine#>%* '
    let dir  = ' %=%<%#StatusLineNC#'.getcwd().'%* '
    return prev.item.next.dir
endfunction
function! CtrlP_Statusline_2(...)
    let len = '%#StatusLine# '.a:1.' %*'
    let dir = ' %=%<%#StatusLineNC# '.getcwd().' %*'
    return len.dir
endfunction
" Start CtrlP in buffer mode
autocmd BufAdd,BufDelete * nnoremap <expr> <C-p> len(getbufinfo({'buflisted':1}))>1 ? ":CtrlPBuffer\<cr>" : ":CtrlP\<cr>"

" Session management
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

" SnipMate parser version
let g:snipMate.snippet_version = 1
" Enable php snippet in html
au BufRead,BufNewFile *.html set ft=html.php

" Gutentags config
let g:gutentags_cache_dir = $HOME.'/gutentags/'
function! GetPwd(path) abort
    return getcwd()
endfunction
let g:gutentags_project_root_finder='GetPwd'
let g:gutentags_add_default_project_roots=0

" Rg config
nnoremap <Leader>/ :Rg<Space>

" Save Renamer buffer with :w
let g:RenamerSupportColonWToRename = 1

" Disable intrusive CSSMinister mapping
autocmd VimEnter * unmap <leader>ha

" Enable demilitMate space expansion
let delimitMate_expand_space = 1

" VCoolor configuration
let g:vcoolor_disable_mappings = 1
nnoremap <silent> ç :VCoolor<cr>
inoremap <silent> ç <esc>:VCoolor<cr>

" Blink cursor after search
" if has('timers')
"   noremap <expr> <plug>(slash-after) 'zz'.slash#blink(2, 50)
" endif

" coc.nvim configuration
set hidden
set signcolumn=yes
let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'
" Correct php variable
autocmd FileType php setl iskeyword+=$
autocmd! Completedone * if pumvisible() == 0 | pclose | endif
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <C-j>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<C-j>" :
      \ coc#refresh()
inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Hexokinase
let g:Hexokinase_signIcon = '■'
autocmd FileType css silent! HexokinaseToggle

" " Vim default
" let g:Hexokinase_highlighters = [ 'sign_column' ]
" " All possible highlighters
" let g:Hexokinase_highlighters = [
" \   'virtual',
" \   'sign_column',
" \   'background',
" \   'backgroundfull',
" \   'foreground',
" \   'foregroundfull'
" \ ]
" " Patterns to match for all filetypes
" let g:Hexokinase_optInPatterns = ['full_hex', 'rgb', 'rgba', 'colour_names']
" " All possible values
" let g:Hexokinase_optInPatterns = [
" \     'full_hex',
" \     'triple_hex',
" \     'rgb',
" \     'rgba',
" \     'hsl',
" \     'hsla',
" \     'colour_names'
" \ ]
" " Filetype specific patterns to match
" " entry value must be comma seperated list
" let g:Hexokinase_ftOptInPatterns = {
" \     'css': 'full_hex,rgb,rgba,hsl,hsla,colour_names',
" \     'html': 'full_hex,rgb,rgba,hsl,hsla,colour_names'
" \ }
" " Sample value, to keep default behaviour don't define this variable
" let g:Hexokinase_ftEnabled = ['css', 'html', 'javascript']

" Vim-Sandwich - enable vim-surround mappings
runtime macros/sandwich/keymap/surround.vim
" Text-objects
xmap is <Plug>(textobj-sandwich-query-i)
xmap as <Plug>(textobj-sandwich-query-a)
omap is <Plug>(textobj-sandwich-query-i)
omap as <Plug>(textobj-sandwich-query-a)
xmap iss <Plug>(textobj-sandwich-auto-i)
xmap ass <Plug>(textobj-sandwich-auto-a)
omap iss <Plug>(textobj-sandwich-auto-i)
omap ass <Plug>(textobj-sandwich-auto-a)
xmap im <Plug>(textobj-sandwich-literal-query-i)
xmap am <Plug>(textobj-sandwich-literal-query-a)
omap im <Plug>(textobj-sandwich-literal-query-i)
omap am <Plug>(textobj-sandwich-literal-query-a)
xmap ip isp
xmap ap asp
omap ip isp
omap ap asp
xmap il isl
xmap al asl
omap il isl
omap al asl
" if you have not copied default recipes
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
" add spaces inside braket
let g:sandwich#recipes += [
      \   {'buns': ['{ ', ' }'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['{']},
      \   {'buns': ['[ ', ' ]'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['[']},
      \   {'buns': ['( ', ' )'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['(']},
      \   {'buns': ['{\s*', '\s*}'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['{']},
      \   {'buns': ['\[\s*', '\s*\]'], 'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['[']},
      \   {'buns': ['(\s*', '\s*)'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['(']},
      \   {'buns': ['<?php\s*', '\s*?>'], 'nesting': 1, 'regex': 1, 'kind': ['textobj'], 'filetype': ['php'], 'input': ['p']},
      \   {'buns': ['^\s*', '\s*$'], 'regex': 1, 'linewise': 1, 'kind': ['textobj'], 'input': ['l']},
      \ ]



" USEFUL SCRIPTS --------------------------------------------------------------------


" Execute macro over visual range
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange() abort
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction


" Execute global commands with confirmation
command! -nargs=+ -complete=command Confirm execute <SID>confirm(<q-args>) | match none
function! s:confirm(cmd) abort
  let abort = 'match none | throw "Confirm: Abort"'
  let options = [abort, a:cmd, '', abort]
  match none
  execute 'match IncSearch /\c\%' . line('.') . 'l' . @/ . '/'
  redraw
  return get(options, confirm('Execute?', "&yes\n&no\n&abort", 2), abort)
endfunction
" Run with :g/[pattern]/Confirm [command]


" Remove all text except what matches the current search result. Will put each match on its own line. This is the opposite of :%s///g (which clears all instances of the current search).
" https://github.com/idbrii/vim-searchsavvy/blob/master/autoload/searchsavvy.vim
function! ClearAllButMatches() range
    let is_whole_file = a:firstline == 1 && a:lastline == line('$')
    let old_c = @c
    let @c=""
    exec a:firstline .','. a:lastline .'sub//\=setreg("C", submatch(0), "l")/g'
    exec a:firstline .','. a:lastline .'delete _'
    put! c
    " I actually want the above to replace the whole selection with c, but I'll settle for removing the blank line that's left when deleting the file contents.
    if is_whole_file
        $delete _
    endif
    let @c = old_c
endfunction


" Remove diacritical signs from characters in specified range of lines.
" Uses substitute so changes can be confirmed.
function! s:RemoveDiacritics(line1, line2) abort
    let diacs = 'áâãàăâçéêíîóôõșşüúţț'  " lowercase diacritical signs
    let repls = 'aaaaaaceeiiooossuutt'  " corresponding replacements
    let diacs .= toupper(diacs)
    let repls .= toupper(repls)
    let diaclist = split(diacs, '\zs')
    let repllist = split(repls, '\zs')
    let trans = {}
    for i in range(len(diaclist))
        let trans[diaclist[i]] = repllist[i]
    endfor
    execute a:line1.','.a:line2 .  's/['.diacs.']/\=trans[submatch(0)]/gIce'
endfunction
command! -range=% RemoveDiacritics call s:RemoveDiacritics(<line1>,<line2>)


" Gutentags set project roots
let g:gutentags_enabled_dirs = ['/Users/cbmssoftware/www']
let g:gutentags_init_user_func = 'CheckEnabledDirs'
function! CheckEnabledDirs(file) abort
    let file_path = fnamemodify(a:file, ':p:h')
    try
        let gutentags_root = gutentags#get_project_root(file_path)
        if filereadable(gutentags_root . '/.withtags')
            return 1
        endif
    catch
    endtry
    for enabled_dir in g:gutentags_enabled_dirs
        let enabled_path = fnamemodify(enabled_dir, ':p:h')
        if match(file_path, enabled_path) == 0
            return 1
        endif
    endfor
    return 0
endfunction


" Capture ex command output
function! Output(cmd) abort
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command Output call Output(<q-args>)
" use as :Output ex-command


" Check for file modifications automatically (current buffer only).
" Use :NoAutoChecktime to disable it (uses b:autochecktime)
fun! MyAutoCheckTime() abort
  " only check timestamp for normal files
  if &buftype != '' | return | endif
  if ! exists('b:autochecktime') || b:autochecktime
    checktime %
    let b:autochecktime = 1
  endif
endfun
augroup MyAutoChecktime
  au!
  au FocusGained,BufEnter,CursorHold * call MyAutoCheckTime()
augroup END
command! NoAutoChecktime let b:autochecktime=0


" Copy all matches
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)


" Diff with saved file
function! s:DiffWithSaved() abort
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
  normal 
endfunction
com! DiffSaved call s:DiffWithSaved()


" Set working directory to project root
function SetProject(s) abort
    if a:s==0
        let path = '/Users/cbmssoftware/www/'
        let projects = []
        let ignore = ['AdminLTE-2.4.0-rc', 'cabin_init', 'cbms_app_init', 'cesaco', 'cordova_icons', 'cbms_app_init', 'cordova_icons', 'deltanet_erp', 'erp.cbms.ro', 'erp2_core_old', 'erp2_old', 'Executive Template', 'fpdf_old', 'gsc_init', 'gsc_old', 'idox', 'iwave', 'magnet', 'masterbuild', 'model', 'oneway_old', 'patterns', 'php', 'phpMyAdmin-4.8.1-english', 'temp', 'temp1', 'temp2', 'temp3', 'temp4', 'temp5', 'temp6', 'test', 'wincon']
        let options = ["Choose local project: ", ""]
        let dir = globpath(path, '*', 0, 1)
        call filter(dir, 'isdirectory(v:val)')
        for i in dir
            if (index(ignore, fnamemodify(i, ':p:h:t'))<0)
                call add(projects, fnamemodify(i, ':p:h:t'))
            endif
        endfor
    else
        let path = '/Volumes/cbmssoftware/www/'
        let projects = ["arhivatorul", "cesaco", "cridov", "dea", "gsc", "ides", "idox", "insidetelecom", "iwave", "mjp", "neotronix", "thermopan"]
        let options = ["Choose ERP2 project: ", ""]
    endif
    if (a:s!=2 && a:s!=3)
        for i in projects
            let n = index(projects, i)+1
            let option = ' '.(n<10 ? ' '.n : n).'. '.i
            call add(options, option)
        endfor
        call inputsave()
        call add(options, '')
        let opt = inputlist(options)
        call inputrestore()
    else
        let opt=1
    endif
    if opt>0 && opt<=len(projects)
        if a:s==0
            exe ":tcd ".path.projects[opt-1]
            normal 
            echon "Working directory set to: "
            echohl MoreMsg | echon projects[opt-1] | echohl None
        else
            exe ":tcd ".path."erp2_core/"
            if a:s==1
                silent exe ":e ".path."erp2/index.php" | silent exe "/Andi" 
                exe "normal! \$F'ci'".projects[opt-1]
                exe "normal! \$F'\"ayi'" | silent exe ":w" | exe ":bd"
                echon "\nSelected project: "
            elseif a:s==2
                silent exe ":e ".path."erp2/index.php" | silent exe "/Andi" 
                exe "normal! \$F'\"ayi'" | silent exe ":bd"
                echon "ERP2 project: "
            else
                exe ":e /Library/Application\ Support/Tunnelblick/Logs/*openvpn.log" | silent exe "/SUCCESS"
                exe "normal! 3f,l\"byt," | exe ":bd"
                silent exe ":e ".path."erp2/index.php" | silent exe "/Andi" 
                exe "normal! 0f'di'\"bP\"aY" | silent exe ":w" | exe ":bd"
            endif
            echohl MoreMsg | echon substitute(@a, '\n$', '', '') | echohl None
        endif
    else
        normal 
        echohl MoreMsg | echon "Nothing changed" | echohl None
    endif
endfunction
