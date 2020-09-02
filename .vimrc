"  _______________________________OG_______________________________
set nocompatible                         "  system-wide vimrc
set backspace=indent,eol,start           "  backspace over indentation, etc
set ruler                                "  always show cursor position
set splitright                           "  default split right
set relativenumber                       "  show relative line number of left
set number                               "  show current line number at cursor
set cursorline                           "  line at cursor row
set incsearch                            "  incremental search for partial /
set hlsearch                             "  search highlighting /
set showcmd                              "  show command on bottom
set autoread                             "  reread files if unmodified
set autoindent                           "  new line inherits indent
set expandtab                            "  tabs to spaces
set tabstop=2
set softtabstop=2 
set shiftwidth=2
set wildignore+=*/tmp/*,*.so,*.swp,*.zip "  ignore these types of files
set history=1000                         "  increase undo limit
set nowrap                               "  disable auto wrap
set hidden                               "  save previous buffer stuff
                                         "" set path=$PWD/** "makes current vim path relative
set ignorecase                           "  ignore case for search
set smartcase                            "  automatically convert search to uppercase
set noswapfile                           "  disable swap files
set tags=tags;/                          "  tags
set t_Co=256
set background=dark
set clipboard^=unnamed,unnamedplus       "  use system clipboard
set scrolloff=10                         "  lines of buffer between top and bottom
set ttimeout
set ttimeoutlen=0
set timeoutlen=1000                      "  time in between commands v,c
syntax enable                            "  colors, overrule with on


"  auto read when leaving window
au FocusLost,WinLeave * :silent! noautocmd w 
au FocusGained,BufEnter * :checktime
au CursorHold,CursorHoldI * checktime




"  _______________________________TEXT EDITING_______________________________

" default 
  map <Space> <Leader>
  let mapleader = "\<Space>"

" nav
  nnoremap J 5j
  nnoremap K 5k
  noremap vA ggVG

" text editing
  map <leader>/ <Plug>NERDCommenterToggle
  " delete entire line
  nnoremap X yydd
  " don't overwrite register
  noremap d "_d
  noremap dd "_dd
  noremap D "_D
  noremap c "_c
  noremap cc "_cc
  noremap C "_C
  "ctrl backspace to delete word?
  imap <C-BS> <C-W>

" undo
  noremap U <C-r><CR>




"  _______________________________PLUGS_______________________________
"  :PlugInstall, :PlugClean

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/autoload')

" file search
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

" text search
  Plug 'jremmen/vim-ripgrep'
  Plug 'mileszs/ack.vim'
  Plug 'epmatsw/ag.vim'

" tmux navigation
  Plug 'christoomey/vim-tmux-navigator'
  " default home screen
  Plug 'mhinz/vim-startify'
    let g:startify_files_number = 15
 
" syntax
  Plug 'tpope/vim-sensible'
  " deletes around ) , etc
  Plug 'wellle/targets.vim'
  " keep pressing f for find
  Plug 'rhysd/clever-f.vim'
    let g:clever_f_across_no_line = 1
  " automatically closes quotes
  Plug 'tmsvg/pear-tree'
    let g:pear_tree_repeatable_expand = 0
    let g:pear_tree_smart_backspace   = 1
    let g:pear_tree_smart_closers     = 1
    let g:pear_tree_smart_openers     = 1
  " <leader + /> to comment
  Plug 'scrooloose/nerdcommenter'
  " multiple cursor w/ <C-n>
  Plug 'terryma/vim-multiple-cursors'
  " easily add/remove parents
  Plug 'tpope/vim-surround'
  " extend repeat commands
  Plug 'tpope/vim-repeat'
  " autoindent stuff, visual-mode, ga + <align-by>
  Plug 'junegunn/vim-easy-align'
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)



" git gud
  Plug 'tpope/vim-fugitive'
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
  Plug 'mhinz/vim-signify'
     set updatetime=100
     let g:signify_line_highlight = 1
     highlight SignifyLineAdd    ctermfg = black ctermbg=DarkGreen      guifg=#005f00             guibg=#005f00
     highlight SignifyLineChange ctermfg = black ctermbg=DarkYellow    guifg=#ffffff guibg=#ff0000
     highlight SignifyLineDelete ctermfg = black ctermbg=red       guifg=#000000 guibg=#ffff00

" language
  Plug 'vim-ruby/vim-ruby'
  Plug 'tpope/vim-rails'
  Plug 'othree/html5.vim'
  Plug 'othree/javascript-libraries-syntax.vim'
  Plug 'hynek/vim-python-pep8-indent'
  Plug 'mxw/vim-jsx'
 
call plug#end()




"  _______________________________FILE NAVIGATION_______________________________
" :Explore, file navigation
  let g:netrw_liststyle = 3      " tree structure
  let g:netrw_banner = 0         " remove banner
  let g:netrw_browse_split = 2   " default open vertical split
  let g:netrw_winsize = 25       " explorer width
  let g:netrw_keepdir = 0
  let g:ag_working_path_mode="r" " ag stuff

  "  turn off quickfix (annoying thing on bottom of screen) w/ <Leader + c> 
  nnoremap <silent> <Leader>c :call QuickFix_toggle()<CR>
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





"  _______________________________FILE SEARCH_______________________________
" Rg ripgrep search
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview(), <bang>0)

" RG full screen
  command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

  function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction




"  _______________________________GENERAL REMAP_______________________________
" search
  cnoreabbrev rg Rg
  cnoreabbrev files GFiles
  cnoreabbrev f GFiles
  nnoremap <silent> <C-f> :GFiles<CR>
  " open new search for selected word
  map <leader>f :rg <c-r>=expand("<cword>")<cr><cr>
  " go to definition
  nnoremap <leader>d :vsplit<CR>:exec("tag ".expand("<cword>"))<CR>


" general
  nmap <Leader>b :Buffers<CR>
  nmap <Leader>h :History<CR>
  nnoremap <leader>w :w<CR>
  cnoreabbrev Q :browse oldfiles              " open :History  in FZF
  cnoreabbrev QQ :History
  cnoreabbrev tree :Explore
  cnoreabbrev b :Buffers


" source / edit
  " source vimrc
  cnoreabbrev sv :source $MYVIMRC<CR>         
  " ag stuff
  cnoreabbrev ve :vsplit $MYVIMRC<CR>         
  " edit ~/.zshrc
  cnoreabbrev ze :vsplit ~/.zshrc<CR>         
  " edit ~/.tc_settings
  cnoreabbrev te :vsplit ~/.tc_settings<CR>   
  " edit notes w/ new line on bottom
  cnoreabbrev n :vsplit ~/notes.md<CR>Go<CR>  

  " Source vim configuration file whenever it is saved
  if has ('autocmd')          " Remain compatible with earlier versions
   augroup Reload_Vimrc       " Group name.  Always use a unique name!
      autocmd!
      autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
      autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
    augroup END
  endif " has autocmd


" buffers
  cnoreabbrev save :SSave
  cnoreabbrev load :SLoad
  "yank relative buffer path
  nnoremap <Leader>yp :let @+=expand("%")<CR> 
  " Copy current file path to clipboard
  nnoremap <leader>% :call CopyCurrentFilePath()<CR>
  function! CopyCurrentFilePath()
    let @+ = expand('%')
    echo @+
  endfunction


" insert move autocomplete
  imap bp binding.pry
  imap bpp <%= binding.pry %>



"_______________________________ BUFFER / WINDOW

" GRAVEYARD
"buffer from top and bottom of screen
"jumping with H,L
"function! JumpWithScrollOff(key) " {{{
  "set scrolloff=0
  "execute 'normal! ' . a:key
  "set scrolloff=999
"endfunction " }}}
"nnoremap H :call JumpWithScrollOff('H')<CR>
"nnoremap L :call JumpWithScrollOff('L')<CR>



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

"ADD LEADER L F to CREATE NEW FIND WINDOW

