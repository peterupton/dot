set nocompatible " be iMproved
"set smartindent " automatic smart indents
set autoindent " do automatic indents
set softtabstop=2 " do "fake" tabs, no spaces
set foldenable " enable folding
set foldlevelstart=1 " fold everything by default
set foldmethod=syntax " figure out what to fold by syntax
set hlsearch " when there is a previous search pattern, highlight all matches
set incsearch " search while typing
set modelines=4 " check 4 lines from top or bottom for modeline commands
set nocompatible "turn new features on
set showcmd  " show command while typing it
set showmatch " show the matching bracket when in insert mode
set wildmenu " enable command completion
imap jk <ESC>
syntax on
set cursorline  " highlight the current line the cursor is on
hi CursorLine term=bold cterm=bold " don't highlight, just bold
set cursorcolumn  " same for column
hi CursorColumn term=bold cterm=bold ctermbg=0  " just bold
set colorcolumn=80,120 " highlight columns 80 and 120
highlight ColorColumn ctermbg=6 " nice blue color for 80 and 120
set ignorecase " case insensitive while searching
set smartcase " case sensitive if you are searching for uppercase
set relativenumber " show number relative to where cursor is
set number " show current line number on left
nnoremap <CR> :noh<CR><CR>
nnoremap ; :
vnoremap ; :
set expandtab " use spaces instead of tabs
set shiftwidth=4  " 4 is default indent
set tabstop=4 " 4 spaces for each tab
set visualbell " don't beep, just flash
nnoremap te yy:execute 'terminal '.@"<cr>  " set te to run the line in terminal
vnoremap te y:execute 'terminal '.@"<cr>

set spell " spell on by default
highlight clear SpellBad  " remove default vim SpellBad highlighting
highlight SpellBad ctermfg=darkred  " just make it dark red

" make sure that .vim dir exists
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif

" make sure that undo dir exists
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "", 0700)
endif

" make sure that backups dir exists
if !isdirectory($HOME."/.vim/backups")
    call mkdir($HOME."/.vim/backups", "", 0700)
endif

" persistent undo file
set undodir=~/.vim/undo
set undofile

set backup  " enable backup files
set backupcopy=yes  " use the "copy" method to not confuse other programs
set backupdir=~/.vim/backups/  " put all backups in homedir

" set the backup file's name to be the current time
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

" more complicated stuff below here
" when vim is invoked witout args, open the current dir with netrw
" Augroup VimStartup:
augroup VimStartup
  au!
  au VimEnter * if expand("%") == "" | e . | endif
augroup END

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
endif

