"og
set nocompatible
set backspace=indent,eol,start
set ruler
set splitright
set relativenumber
set number
set cursorline
set incsearch
set hlsearch
set showcmd
set autoread
syntax on
set autoindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set history=10000
set nowrap
set hidden
set path=$PWD/**
set ignorecase
set smartcase
set noswapfile
set tags=tags;/
"for vim-signify
set updatetime=100
set t_Co=256
set background=dark
set clipboard^=unnamed,unnamedplus
" lines of buffer between top and bottom
set scrolloff=10


au FocusLost,WinLeave * :silent! noautocmd w
au FocusGained,BufEnter * :checktime
au CursorHold,CursorHoldI * checktime



"_______________________________ PLUGS 
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
  Plug 'mileszs/ack.vim'
  Plug 'epmatsw/ag.vim'
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
  "GIT DIFF
  Plug 'tpope/vim-fugitive'
    nnoremap <silent> <leader>gs :Gstatus<CR>
      nnoremap <silent> <leader>gd :Gdiff<CR>
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
  Plug 'scrooloose/nerdcommenter'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'rhysd/clever-f.vim'
  " {{{
    let g:clever_f_across_no_line = 1
  " }}}
  Plug 'vim-ruby/vim-ruby'
  Plug 'tpope/vim-rails'
  Plug 'othree/html5.vim'
  Plug 'othree/javascript-libraries-syntax.vim'
  Plug 'gavocanov/vim-js-indent'
  Plug 'hynek/vim-python-pep8-indent'
  Plug 'mxw/vim-jsx'
  "multiple cursor w/ <C-n>
  Plug 'terryma/vim-multiple-cursors'
  "surround ([( highlighted, csW in word
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'mhinz/vim-startify'

call plug#end()





"_______________________________ SIMPLE REMAPS

map <leader>/ <Plug>NERDCommenterToggle
nnoremap J 5j
nnoremap K 5k
nnoremap X yydd
map <Space> <Leader>
noremap vA ggVG
noremap d "_d
noremap dd "_dd
noremap D "_D
noremap c "_c
noremap cc "_cc
noremap C "_C
cnoreabbrev rg Rg
cnoreabbrev files GFiles
cnoreabbrev f GFiles
nnoremap <silent> <C-f> :GFiles<CR>

imap <C-BS> <C-W>
let mapleader = "\<Space>" 






"_______________________________ FILE STUFF
" tree structure
let g:netrw_liststyle = 3
" remove banner
let g:netrw_banner = 0
" default open vertical split
let g:netrw_browse_split = 2
" explorer width
let g:netrw_winsize = 25
let g:netrw_keepdir = 0
" ag stuff
let g:ag_working_path_mode="r"

"RipGrep (search) defaults
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

"turn off quickfix
function! QuickFix_toggle()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            cclose
            return
        endif
    endfor

    copen
endfunction
nnoremap <silent> <Leader>c :call QuickFix_toggle()<CR>

"buffer from top and bottom of screen
"jumping with H,L
"function! JumpWithScrollOff(key) " {{{
  "set scrolloff=0
  "execute 'normal! ' . a:key
  "set scrolloff=999
"endfunction " }}}
"nnoremap H :call JumpWithScrollOff('H')<CR>
"nnoremap L :call JumpWithScrollOff('L')<CR>




"_______________________________ ETC

nmap <Leader>b :Buffers<CR>
nmap <Leader>h :History<CR>


nnoremap <leader>w :w<CR>

"source vimrc
cnoreabbrev sv :source $MYVIMRC<CR>
"edit vimrc
cnoreabbrev ve :vsplit $MYVIMRC<CR>
"edit ~/.zshrc
cnoreabbrev ze :vsplit ~/.zshrc<CR>
"edit ~/.tc_settings
cnoreabbrev te :vsplit ~/.tc_settings<CR>
"edit notes w/ new line on bottom
cnoreabbrev n :vsplit ~/notes.md<CR>Go<CR>




" Source vim configuration file whenever it is saved
if has ('autocmd')          " Remain compatible with earlier versions
 augroup Reload_Vimrc       " Group name.  Always use a unique name!
    autocmd!                
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
endif " has autocmd

"yank relative buffer path
nnoremap <Leader>yp :let @+=expand("%")<CR>

" Copy current file path to clipboard
nnoremap <leader>% :call CopyCurrentFilePath()<CR>
function! CopyCurrentFilePath() " {{{
  let @+ = expand('%')
  echo @+
endfunction
" }}}

"open new search for selected word
map <leader>f :rg <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>d :vsplit<CR>:exec("tag ".expand("<cword>"))<CR>

" insert mapping
imap bp binding.pry
imap bpp <%= binding.pry %>






"_______________________________ BUFFER / WINDOW

"open buffer
nnoremap <leader>b :ls<cr>:b<space>
nnoremap <leader>v :ls<cr>:vsp<space>\|<space>b<space>
nnoremap <leader>s :ls<cr>:sp<space>\|<space>b<space>
nnoremap <leader>o :only

"resize window
nnoremap <silent> <Leader>> 20<C-w>>
nnoremap <silent> <Leader>< 20<C-w><
nnoremap <silent> <Leader>= <C-w>=


" Switch between tabs
nmap <leader>1 1gt
nmap <leader>2 2gt
nmap <leader>3 3gt
nmap <leader>4 4gt
nmap <leader>5 5gt
nmap <leader>6 6gt
nmap <leader>7 7gt
nmap <leader>8 8gt
nmap <leader>9 9gt
" add Switch between buffers w/ !@#$%^&*()


" Creating splits with empty buffers in all directions
nnoremap <Leader>hn :leftabove  vnew<CR>
nnoremap <Leader>ln :rightbelow vnew<CR>
nnoremap <Leader>kn :leftabove  new<CR>
nnoremap <Leader>jn :rightbelow new<CR>

" If split in given direction exists - jump, else create new split
function! JumpOrOpenNewSplit(key, cmd, fzf) " {{{
  let current_window = winnr()
  execute 'wincmd' a:key
  if current_window == winnr()
    execute a:cmd
    if a:fzf
      Files
    endif
  else
    if a:fzf
      Files
    endif
  endif
endfunction " }}}
nnoremap <silent> <Leader>hh :call JumpOrOpenNewSplit('h', ':leftabove vsplit', 0)<CR>
nnoremap <silent> <Leader>ll :call JumpOrOpenNewSplit('l', ':rightbelow vsplit', 0)<CR>
nnoremap <silent> <Leader>kk :call JumpOrOpenNewSplit('k', ':leftabove split', 0)<CR>
nnoremap <silent> <Leader>jj :call JumpOrOpenNewSplit('j', ':rightbelow split', 0)<CR>

" Same as above, except it opens unite at the end
nnoremap <silent> <Leader>h<Space> :call JumpOrOpenNewSplit('h', ':leftabove vsplit', 1)<CR>
nnoremap <silent> <Leader>l<Space> :call JumpOrOpenNewSplit('l', ':rightbelow vsplit', 1)<CR>
nnoremap <silent> <Leader>k<Space> :call JumpOrOpenNewSplit('k', ':leftabove split', 1)<CR>
nnoremap <silent> <Leader>j<Space> :call JumpOrOpenNewSplit('j', ':rightbelow split', 1)<CR>


" ADD <C-HJKL> TO CREATE WINDOW
