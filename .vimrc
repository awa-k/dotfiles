"
" vimrc
"

augroup MyCmd
    autocmd!
augroup END

augroup PrevimSettings
    autocmd!
    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END
"
set nocompatible

" backup etc.
set backupdir=~/.vim-backup
set directory=~/.vim-backup
set undodir=~/.vim-backup

" view
set antialias
set colorcolumn=80
set cursorline
set display=uhex
set hlsearch
set incsearch
set infercase
set laststatus=2
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set matchpairs+=<:>
set matchtime=3
set modeline
set notitle
set nowrap
set number
set ruler
set showcmd
set showmatch
set noshowmode
set smartcase
set virtualedit=all
set wildmenu

" layout
set ambiwidth=double
set autoindent
set backspace=indent,eol,start
set expandtab
set shiftround
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set tabstop=4

" env
"set autochdir
set autoread
set ignorecase

" buffer
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus unnamed
else
    set clipboard& clipboard+=unnamed
endif

set hidden
set switchbuf=useopen

" auto escape
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" cursorline
autocmd WinEnter * setl cursorline
autocmd WinLeave * setl nocursorline

" other options
syntax enable

"
" neobundle base
"
filetype off

if has('vim_starting')
    set nocompatible
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

" plug-ins from Shougo
NeoBundle 'Shougo/vimproc.vim', {
            \ 'build': {
            \ 'mac':'make -f make_mac.mak',
            \ 'unix':'gmake',
            \ }}
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'Shougo/vimshell.vim'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'

" themes
NeoBundle 'w0ng/vim-hybrid'

" powerline
" NeoBundle 'alpaca-tc/alpaca_powertabline'
" NeoBundle 'Lokaltog/powerline', {
"            \ 'rtp' : 'powerline/bindings/vim' }
NeoBundle 'itchyny/lightline.vim'
" NeoBundle 'itchyny/landscape.vim'

" snippets
NeoBundle 'scrooloose/syntastic'
NeoBundle 'honza/vim-snippets'
NeoBundle 'godlygeek/tabular'
NeoBundle 'fatih/vim-go'

" git
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'airblade/vim-gitgutter'

" puppet
NeoBundle 'rodjek/vim-puppet'

" shaberu
NeoBundle 'supermomonga/shaberu.vim'

" markdown
NeoBundle 'kannokanno/previm'

" open-browser
NeoBundle 'tyru/open-browser.vim'

call neobundle#end()

filetype plugin indent on

NeoBundleCheck

"
" color theme
"
set background=dark
let g:hybrid_use_iTerm_colors = 1
colorscheme hybrid

"
" snippets
"
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
  set conceallevel=2 concealcursor=i
endif

" Enable vimfiler on startup
let g:vimfiler_as_default_explorer = 1
" Enable neocomplete on startup
let g:neocomplete#enable_at_startup = 1

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
" Enable syntastic
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1
" Enable previm
"let g:previm_open_cmd = '/usr/bin/open -a Chrome'

" lightline color
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'mode_map': {'c': 'NORMAL'},
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'MyModified',
      \   'readonly': 'MyReadonly',
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode'
      \ }
      \ }

function! MyModified()
    return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
    return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
    return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
                \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
                \  &ft == 'unite' ? unite#get_status_string() :
                \  &ft == 'vimshell' ? vimshell#get_status_string() :
                \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
                \ ('' != MyModified() ? ' ' . MyModified() : '')
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

function! MyFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
    return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
    return winwidth(0) > 60 ? lightline#mode() : ''
endfunction
