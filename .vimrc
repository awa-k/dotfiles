if 0 | endif

" NeoBundle
if has('vim_starting')
    if &compatible
        set nocompatible
    endif
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
" Shougo's plugin
NeoBundle 'Shougo/vimproc.vim', {
    \ 'build': {
        \ 'unix':'gmake',
        \ 'mac':'make -f make_mac.mak',
        \ 'linux':'make',
    \ }}
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimshell.vim'
NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'

" themes & powerline
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'itchyny/lightline.vim'

" git (& required by lightline)
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'airblade/vim-gitgutter'

" snippets & templates
NeoBundle 'scrooloose/syntastic'
NeoBundle 'honza/vim-snippets'
NeoBundle 'godlygeek/tabular'
NeoBundle 'mattn/sonictemplate-vim'

" golang
NeoBundle 'fatih/vim-go'
NeoBundle 'majutsushi/tagbar'

" puppet
NeoBundle 'rodjek/vim-puppet'

" markdown
NeoBundle 'kannokanno/previm'
NeoBundle 'tyru/open-browser.vim'

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

" Shougo's settings
let g:vimfiler_as_default_explorer = 1
let g:neocomplete#enable_at_startup = 1

" themes & powerline
set background=dark
let g:hybrid_use_Xresources = 1
colorscheme hybrid

let g:gitgutter_sign_added = 'a' 
let g:gitgutter_sign_modified = 'm'
let g:gitgutter_sign_removed = 'r'

let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ 'mode_map': {'c': 'NORMAL'},
    \ 'active': {
    \   'left': [
    \     ['mode', 'paste'],
    \     ['fugitive', 'gitgutter', 'filename'],
    \   ],
    \   'right': [
    \     ['lineinfo', 'syntastic'],
    \     ['percent'],
    \     ['fileformat', 'fileencoding', 'filetype'],
    \   ],
    \ },
    \ 'component_function': {
    \   'mode': 'MyMode',
    \   'modified': 'MyModified',
    \   'readonly': 'MyReadonly',
    \   'fugitive': 'MyFugitive',
    \   'gitgutter': 'MyGitgutter',
    \   'filename': 'MyFilename',
    \   'syntastic': 'SyntasticStatuslineFlag',
    \   'fileformat': 'MyFileformat',
    \   'fileencoding': 'MyFileencoding',
    \   'filetype': 'MyFiletype',
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }

function! MyMode()
    return winwidth('.') > 60 ? lightline#mode() : ''
endfunction

function! MyModified()
    return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
    return &ft !~? 'help\|vimfiler\|gundo' && &ro ? 'x' : ''
endfunction

function! MyFugitive()
    try
        if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
            return fugitive#head()
        endif
    catch
    endtry
    return ''
endfunction

function! MyGitgutter()
    if ! exists('*GitGutterGetHunkSummary')
                \ || ! get(g:, 'gitgutter_enabled', 0)
                \ || winwidth('.') <= 90
        return ''
    endif
    let symbols = [
        \ g:gitgutter_sign_added . ' ',
        \ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
    let hunks = GitGutterGetHunkSummary()
    let ret = []
    for i in [0, 1, 2]
        if hunks[i] > 0
            call add(ret, symbols[i] . hunks[i])
        endif
    endfor
    return join(ret, ' ')
endfunction

function! MyFilename()
    return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? substitute(b:vimshell.current_dir,expand('~'),'~','') :
        \  '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFileformat()
    return winwidth('.') > 70 ? &fileformat : ''
endfunction

function! MyFileencoding()
    return winwidth('.') > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyFiletype()
    return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

" snippets, etc.
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs = 1

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory ='~/.vim/bundle/vim-snippets/snippets'

" auto escape key-mappings.
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" markdown
augroup PrevimSettings
    autocmd!
    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

syntax enable

" backup, etc.
set backupdir=~/.vim-backup
set undodir=~/.vim-backup
set nowritebackup
set nobackup
set noswapfile

" buffer
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus unnamed
else
    set clipboard& clipboard+=unnamed
endif

" layout
set ambiwidth=double
set backspace=indent,eol,start
set autoindent
set expandtab
set shiftround
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set tabstop=4

" view
set antialias
set autoread
set colorcolumn=80
set cursorline
set display=lastline,uhex
set hidden
set hlsearch
set ignorecase
set incsearch
set infercase
set laststatus=2
set list
set listchars=eol:↲,tab:»-,trail:-,extends:»,precedes:«,nbsp:%
set matchpairs+=<:>
set matchtime=5
set modeline
set number
set ruler
set showcmd
set showmatch
set noshowmode
set smartcase
set switchbuf=useopen
set notitle
set nowrap
set virtualedit=all
set visualbell
set wildmenu

" vim: set ft=vim:
