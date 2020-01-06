try
  source ~/.custom.vim
catch
endtry

""" basic

" Auto change dir (help with buffer name)
" https://vi.stackexchange.com/questions/3314/short-buffer-name
" set autochdir

" Auto close brackets
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" mattn/gist-vim
let g:gist_detect_filetype = 1
let g:gist_show_privates = 1
let g:gist_get_multiplefile = 1

" commentary
autocmd FileType helm setlocal commentstring=#\ %s

" search fuzzy
set path+=**
set wildmenu

" use relative number
" set relativenumber

" no legacy support
set nocompatible

" repeat substitution
nnoremap & :&&<CR>
xnoremap & :&&<CR>

""" leader key
" let mapleader="<M>"

" disable command line mode
map q: :q
" disable recording
map q <Nop>
" get current path
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif


" Ignore case when searching
set ignorecase

" spell check
" set spell spelllang=en_us

" Show matching brackets when text indicator is over them
set showmatch

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

set wrap "Wrap lines

syntax enable

""" tpl
autocmd FileType tpl setlocal noeol binary

""" markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = ['go', 'python', 'bash=sh', 'yaml']
let g:markdown_syntax_conceal = 0
let g:markdown_minlines = 100
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0

augroup PrevimSettings
  autocmd!
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

""" json
let g:vim_json_syntax_conceal = 0

""" NERDTree
" map <C-n> :NERDTreeTabsToggle<CR><C-w><C-w>
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" let NERDTreeChDirMode=2
" let g:NERDTreeWinSize=20
" let g:NERDTreeDirArrowExpandable = '├'
" let g:NERDTreeDirArrowCollapsible = '└'
" let g:NERDTreeMapActivateNode = '<tab>'
" let g:NERDTreeShowHidden = 1
" au VimEnter *  NERDTree | wincmd p

""" use terminal
set splitbelow
let g:disable_key_mappings = 1
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-v><Esc> <Esc>
endif

" au TermClose * call feedkeys("\<cr>")

""" highlight line number
set nu
set cursorline
hi cursorline cterm=none
hi cursorlinenr ctermfg=green

""" zoom pane
nnoremap <C-w>z :tabedit %<CR>

""" fuzzy search
nnoremap <C-p> :<C-u>FZF<CR>
nnoremap <C-w>h :History:<CR>

""" Ctrl a,e
nnoremap <C-e> <Esc>i<C-o>$
nnoremap <C-a> <Esc>i<C-o>0

inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>0

set undodir=~/.vimundodir
set undofile
set softtabstop=2 expandtab shiftwidth=2 smarttab
set autoread
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
filetype plugin on
set mouse=a
set showcmd
set splitright
set conceallevel=0
set concealcursor=niv

" set list
" set listchars=tab:!·,trail:·,
"let g:indentLine_char = ''
"let g:indentLine_first_char = ''
"let g:indentLine_showFirstIndentLevel = 1
"let g:indentLine_setColors = 1

""" netrw
" let g:netrw_liststyle = 3
" let g:netrw_banner = 1
" let g:netrw_winsize = 15
"
" let g:netrw_browse_split = 0
" let g:netrw_altv = 1
" let g:loaded_netrw       = 1
" let g:loaded_netrwPlugin = 1

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0


" Use deoplete.
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave * silent! pclose!
let g:deoplete#sources#jedi#python_path = '/Users/tuannvm/.pyenv/shims/python'
let g:deoplete#sources#jedi#show_docstring = 1

if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
" let g:deoplete#disable_auto_complete = 1
" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" deoplete.nvim recommend
set completeopt+=noselect
let g:deoplete#sources#go#gocode_binary = '/Users/tuannvm/golang/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']

"""

""" python """
let g:formatterpath = ['/usr/local/bin/flake8']
au BufWrite *.py :Autoformat
autocmd FileType python let b:autoformat_autoindent=0
autocmd FileType python let g:autoformat_retab = 0
autocmd FileType python let g:autoformat_remove_trailing_spaces = 1

" Path to python interpreter for neovim
let g:python3_host_prog  = '/Users/tuannvm/.pyenv/shims/python'
let g:python_host_prog  = '/Users/tuannvm/.pyenv/shims/python'
" Skip the check of neovim module
let g:python3_host_skip_check = 0

" tag
nmap <F8> :TagbarToggle <CR>

"" let @p='i ^[p']'
autocmd BufRead,BufNewFile */templates/*.yaml,*/templates/*.tpl set ft=helm

" let g:UltiSnipsExpandTrigger="<tab>"
" let g:neosnippet#disable_runtime_snippets = 1
" imap <expr><TAB>
"  \ pumvisible() ? "\<C-n>" :
"  \ neosnippet#expandable_or_jumpable() ?
"  \
"\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" terraform
let g:terraform_fmt_on_save=1

set hidden

nnoremap <F10> :call LanguageClient_contextMenu()<CR>
nnoremap ff :call LanguageClient#textDocument_hover()<CR>

let g:ack_default_options =
      \ " --smart-case"

nnoremap H gT
nnoremap L gt

""" hide status bar
let s:hidden_all = 0
function! ToggleHiddenAll()
  if s:hidden_all  == 0
    let s:hidden_all = 1
    set noshowmode
    set noruler
    set laststatus=0
    set noshowcmd
  else
    let s:hidden_all = 0
    set showmode
    set ruler
    set laststatus=2
    set showcmd
  endif
endfunction

nnoremap <S-h> :call ToggleHiddenAll()<CR>

""" Gist
let g:gist_detect_filetype = 1
let g:gist_show_privates = 1
let g:gist_get_multiplefile = 1
let g:gist_post_private = 1


""" Table
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
      \ <SID>isAtStartOfLine('\|\|') ?
      \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
      \ <SID>isAtStartOfLine('__') ?
      \ '<c-o>:silent! TableModeDisable<cr>' : '__'

let g:table_mode_corner='|'

""" Tab keymap

" switch tabs with Alt left and right
nnoremap <A-right> :tabnext<CR>
nnoremap <A-left> :tabprevious<CR>
" and whilst in insert mode
inoremap <A-right> <Esc>:tabnext<CR>
inoremap <A-left> <Esc>:tabprevious<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim-go
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

let g:LanguageClient_serverCommands = {
      \ 'go': ['go-langserver'],
      \ }

""" go language
let g:go_version_warning = 0

let s:tlist_def_go_settings = 'go;g:enum;s:struct;u:union;t:type;' .
      \ 'v:variable;f:function'

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4


let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [
      \ 'p:package',
      \ 'i:imports:1',
      \ 'c:constants',
      \ 'v:variables',
      \ 't:types',
      \ 'n:interfaces',
      \ 'w:fields',
      \ 'e:embedded',
      \ 'm:methods',
      \ 'r:constructor',
      \ 'f:functions'
      \ ],
      \ 'sro' : '.',
      \ 'kind2scope' : {
      \ 't' : 'ctype',
      \ 'n' : 'ntype'
      \ },
      \ 'scope2kind' : {
      \ 'ctype' : 't',
      \ 'ntype' : 'n'
      \ },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
      \ }

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_type_info = 0
let g:go_info_mode='godoc'
let g:go_auto_sameids = 1

autocmd FileType go nmap <leader>j :lnext<CR>
autocmd FileType go nmap <leader>k :lprevious<CR>
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>i  <Plug>(go-doc)
au FileType go nmap <F12> <Plug>(go-def)
au Filetype go nmap <leader>ga <Plug>(go-alternate-edit)
au FileType go nmap <leader>gah <Plug>(go-alternate-split)
au FileType go nmap <leader>gav <Plug>(go-alternate-vertical)
au FileType go nmap <F9> :GoCoverageToggle -short<cr>
au FileType go nmap <leader>d :GoToggleBreakpoint<cr>
au FileType go nmap <leader>D :GoDebug<cr>
au FileType go nmap <leader>G :GoImpl

let g:go_metalinter_enabled = ['vet', 'golint', 'gofmt', 'errcheck']
let g:go_metalinter_autosave = 1
let g:go_addtags_transform = "snakecase"
let g:go_fmt_command = "goimports"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ALE (syntax checker)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters = {
      \   'golang': ['gopls'],
      \   'markdown': ['markdownlint', '-c', '~/.config/markdownlint/config'],
      \   'yaml': ['yamllint'],
      \   'terraform': ['tflint']
      \}
let g:ale_echo_cursor = 1
let g:ale_fix_on_save = 1
" use nice symbols for errors and warnings
set signcolumn=no
" highlight clear ALEErrorSign
" highlight clear ALEWarningSign
" let g:ale_sign_error = '💣'
" let g:ale_sign_warning = '⚠'

" fixer configurations
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}

nmap <silent> <leader>a <Plug>(ale_next_wrap)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status bar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! StatusLine(current, width)
  return (a:current ? crystalline#mode() . '%#Crystalline#' : '%#CrystallineInactive#')
        \ . ' %f%h%w%m%r '
        \ . (a:current ? '%#CrystallineFill# ' : '')
        \ . '%=' . (a:current ? '%#Crystalline# %{&paste?"PASTE ":""}%{&spell?"SPELL ":""}' . crystalline#mode_color() : '')
        \ . (a:width > 80 ? ' [%{&enc}][%{&ffs}] %l/%L %P ' : ' ')
endfunction

function! TabLine()
  let l:vimlabel = " TOKI "
  return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'default'

set showtabline=1
set laststatus=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Git gutter (Git diff)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_enabled=1
set updatetime=500
nnoremap <silent> <leader>d :GitGutterToggle<cr>
" Jump between hunks
nmap <Leader>gn <Plug>GitGutterNextHunk  " git next
nmap <Leader>gp <Plug>GitGutterPrevHunk  " git previous
nmap <Leader>ga <Plug>GitGutterStageHunk  " git add (chunk)
nmap <Leader>gu <Plug>GitGutterUndoHunk   " git undo (chunk)
nnoremap <leader>gs :Magit<CR>       " git status
" Push to remote
nnoremap <leader>gP :! git push<CR>  " git Push
" Show commits for every source line
nnoremap <Leader>gb :Gblame<CR>  " git blame

" augroup lexical
"   autocmd!
"   autocmd FileType markdown,mkd call lexical#init()
"   autocmd FileType textfile,text call lexical#init()
" augroup END

let g:indentLine_enabled = 1


""" grep
set grepprg=ack
let g:grep_cmd_opts = '--noheading'
nnoremap <C-g> :Grepper<CR>

""" Custom function

" trim whitespace
fun! TrimWhitespace()
  let l:save = winsaveview()
  %s/\s\+$//e
  call winrestview(l:save)
endfun

command! TrimWhitespace call TrimWhitespace()

""" nested vim
if has('nvim') && executable('nvr')
  let $VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
endif
