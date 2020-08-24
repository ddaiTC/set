"og
set nocompatible

set backspace=indent,eol,start
set ruler
set splitright
set relativenumber
set cursorline
set incsearch
set hlsearch
set showcmd
"set autochdir
syntax on
set ts=4
set autoindent
set softtabstop=4
imap <C-BS> <C-W>
let mapleader = "\<Space>" 
" tree structure
let g:netrw_liststyle = 3
" remove banner
let g:netrw_banner = 0
" default open vertical split
let g:netrw_browse_split = 2
" explorer width
let g:netrw_winsize = 25
nnoremap J 5j
nnoremap K 5k

let g:netrw_keepdir = 0

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \ "rg --column --line-number --no-heading --color=always --smart-case " .
  \ <q-args>, 1, fzf#vim#with_preview(), <bang>0)



"vim-plug
":source ~/.vimrc
":PlugInstall
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/autoload')
Plug 'tpope/vim-sensible'

"fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"colors
Plug 'bluz71/vim-moonfly-colors'
Plug 'bluz71/vim-nightfly-guicolors'

"deletes around ) , etc
Plug 'wellle/targets.vim'
"keep pressing f for find
Plug 'rhysd/clever-f.vim'

"automatically closes quotes
Plug 'tmsvg/pear-tree'
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_backspace   = 1
let g:pear_tree_smart_closers     = 1
let g:pear_tree_smart_openers     = 1

"ripgrep"
Plug 'jremmen/vim-ripgrep'



call plug#end()

"aliases to make
"call fzf: vim -o `fzf`
"vim $(fzf)

