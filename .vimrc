"
" Katz's vimrc
"

"
" set options
"
set notitle
set nocompatible
set autoindent
set smartindent
set nobackup
set noswapfile
set clipboard+=unnamed
set backspace=2
set title
set number
set ruler
set laststatus=2
set antialias
set showmatch
set nolist
set showmode
set showcmd
set display=uhex
set wildmenu
set nowrap
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noincsearch
set wrapscan
set ignorecase
set smartcase
set hlsearch
set cursorline

"
" autocmd options
"
autocmd WinEnter * setl cursorline
autocmd WinLeave * setl nocursorline

"
" other options
"
syntax enable

"
" encoding
"
set encoding=utf-8
set fenc=utf-8
set fencs=iso-2022-jp,euc-jp,cp932
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif

"
" plugins
"
filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim

    call neobundle#rc(expand('~/.vim/bundle'))
endif

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache'

NeoBundle 'Lokaltog/vim-powerline'

filetype plugin on
filetype indent on

"
" for vim-powerline
"
set t_Co=256
let g:Powerline_symbols = 'fancy'

"
" for colors
"
colorscheme molokai
