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

" utils
NeoBundle 'sjl/gundo.vim'

" git (& required by lightline)
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'airblade/vim-gitgutter'

" snippets & templates
NeoBundle 'scrooloose/syntastic'
NeoBundle 'honza/vim-snippets'
NeoBundle 'godlygeek/tabular'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'mattn/sonictemplate-vim'

" golang
NeoBundle 'fatih/vim-go'

" erlang
NeoBundle 'vim-erlang/vim-erlang-runtime'
NeoBundle 'vim-erlang/vim-erlang-tags'
NeoBundle 'vim-erlang/vim-erlang-compiler'
NeoBundle 'vim-erlang/vim-erlang-omnicomplete'
NeoBundle 'vim-erlang/erlang-motions.vim'
NeoBundle 'vim-erlang/vim-rebar'
NeoBundle 'vim-erlang/vim-dialyzer'
NeoBundle 'vim-erlang/vim-erlang-skeletons'

" puppet
NeoBundle 'rodjek/vim-puppet'

" markdown
NeoBundle 'kannokanno/previm'
NeoBundle 'tyru/open-browser.vim'

" cisco ios
NeoBundle 'CyCoreSystems/vim-cisco-ios'

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
    \   'left': [ ['mode', 'paste'], ['fugitive', 'filename'], ]
    \ },
    \ 'component_function': {
    \   'mode': 'MyMode',
    \   'modified': 'MyModified',
    \   'readonly': 'MyReadonly',
    \   'fugitive': 'MyFugitive',
    \   'filename': 'MyFilename',
    \   'fileformat': 'MyFileformat',
    \   'fileencoding': 'MyFileencoding',
    \   'filetype': 'MyFiletype',
    \ },
    \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
    \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
    \ }

function! MyMode()
    return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! MyModified()
    return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
    return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? "\ue0a2" : ''
endfunction

function! MyFugitive()
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
        let _ = fugitive#head()
        return strlen(_) ? "\ue0a0"._ : ''
    endif
    return ''
endfunction

function! MyFilename()
    return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
          \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
          \  &ft == 'unite' ? unite#get_status_string() :
          \  &ft == 'vimshell' ? vimshell#get_status_string() :
          \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
          \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFileencoding()
    return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

" snippets, etc.
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_enable_signs = 1

let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory ='~/.vim/bundle/vim-snippets/snippets'

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" omni
imap <C-f> <C-x><C-o>

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

" key-mappings.
" auto escape
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" nohlsearch
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" golang
if filereadable(expand('~/dotfiles/.vimrc_go'))
    source ~/dotfiles/.vimrc_go
endif

" erlang
if filereadable(expand('~/dotfiles/.vimrc_erlang'))
    source ~/dotfiles/.vimrc_erlang
endif

" markdown
augroup PrevimSettings
    autocmd!
    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

" reload vimrc
augroup ReloadVimrc
    autocmd!
    autocmd BufWritePost *vimrc nested source $MYVIMRC
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
"set autochdir
set autoread
set colorcolumn=80
set completeopt=menu,preview
set cursorline
set display=lastline,uhex
set grepprg=jvgrep
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
