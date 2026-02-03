set nocompatible              " be iMproved, required

" Check python version if available
if has("python")
    python import vim; from sys import version_info as v; vim.command('let python_version=%d' % (v[0] * 100 + v[1]))
else
    let python_version=0
endif

if python_version >= 3  " if we have reasonable python
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'ycm-core/YouCompleteMe'
call vundle#end()            " required
filetype plugin indent on    " required
" Brief Vundle help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
endif

set wildmenu " enable command completion
set lazyredraw
set showmatch
set incsearch
set hlsearch
set nocompatible "turn new features on
set foldenable " enable folding
set foldlevelstart=10
set foldmethod=indent
set showcmd
set modelines=4
imap jk <ESC> " map jk to <ESC> when in insert mode
syntax on
set cursorline
hi CursorLine term=bold cterm=bold
set cursorcolumn
hi CursorColumn term=bold cterm=bold ctermbg=0
set colorcolumn=80,120 " highlight columns 80 and 120
highlight ColorColumn ctermbg=6
set ignorecase " case insensitive while searching
set smartcase
set relativenumber
set number
nnoremap <CR> :noh<CR><CR>
nnoremap ; :
vnoremap ; :
set visualbell
set tabstop=4 shiftwidth=4 expandtab  " use spaces instead of tabs, 4 spaces for each tab
inoremap <C-v> <ESC>"+pa
vnoremap <C-c> "+y
vnoremap <C-x> "+d
nnoremap te yy:execute 'terminal '.@"<cr>  " set te to run the line in terminal
vnoremap te y:execute 'terminal '.@"<cr>
if version >= 600
  filetype plugin indent on
endif
" when vim is invoked witout args, open the current dir with netrw
" Augroup VimStartup:
augroup VimStartup
  au!
  au VimEnter * if expand("%") == "" | e . | endif
augroup END
set spell " spell on by default
highlight clear SpellBad
highlight SpellBad ctermfg=darkred

set backup

function! BackupDir()
   if has('win32') || has('win64')
      let l:backupdir=$VIM.'/backup/'.
               \substitute(expand('%:p:h'), '\:', '~', '')
   else
      let l:backupdir=$HOME.'/.vim/backup/'.
               \substitute(expand('%:p:h'), '^'.$HOME, '~', '')
   endif

   if !isdirectory(l:backupdir)
      call mkdir(l:backupdir, 'p', 0700)
   endif

   let &backupdir=l:backupdir
   let &backupext=strftime('~%Y-%m-%d_%H-%M-%S~')
endfunction

autocmd! bufwritepre * call BackupDir()
