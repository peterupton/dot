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
