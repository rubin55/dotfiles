" Turn off compatible mode.
set nocompatible

" VimPlug section.
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/syntastic'
Plug 'myint/syntastic-extras'
Plug 'Valloric/YouCompleteMe'
Plug 'wkentaro/conque.vim'
Plug 'tpope/vim-fireplace'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
call plug#end()

" Main options.
syntax on
filetype on
filetype plugin on
filetype indent on
"scriptencoding utf-8

" Set color mode.
set t_Co=256
colorscheme base16-default-dark
"let g:airline_theme='base16'

" File encoding settings.
set encoding=utf-8
set fileformat=unix
set fileformats=unix,dos

" Search options.
set ignorecase
set incsearch
set smartcase
set hlsearch

" Only do soft-wraps.
set linebreak
set wrap

" Setup backspace and tab settings.
set backspace=indent,eol,start
set listchars=tab:>-,eol:$
set tabstop=4
set shiftwidth=4
set expandtab

" Set the command, match and statusline.
set showcmd
set showmatch
set showmode
set cmdheight=1
set laststatus=2

" Some performance extras.
set lazyredraw
set ttyfast

" Enable command completion.
set wildmenu
set wildchar=<Tab>
set wildmode=longest:full,list:full
set wildignore=*.swp,*.bak,*.pyc,*.class

" Viminfo settings.
set viminfo='500,f1,:100,/100

" Disable backup files.
set noswapfile
set nobackup
set nowritebackup

" Assume a dark background.
set background=dark

" Settings for gvim.
if has("gui_running")
  set lines=40 columns=120
  if has("gui_gtk2")
    set guifont=Powerline\ Consolas\ 11
  elseif has("gui_macvim")
    set guifont=Powerline\ Monaco:h13
  elseif has("gui_win32")
    set guifont=Powerline\ Consolas:h10
  endif
endif

" Go to last visited line on open.
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Set certain file extensions to specific filetypes.
au BufRead,BufNewFile *.pc set filetype=esqlc

" Don't to spaces for tabs in makefiles.
au FileType make set noexpandtab

" Don't create a backup file for crontab edits.
au FileType crontab set nobackup

" Remove unnecessary white space on save.
autocmd BufWritePre * %s/\s\+$//e

" Highlight unnecessary white space.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/

" Extra indenting options for shell scripts.
if !exists("b:sh_indent_options")
  let b:sh_indent_options = {}
endif
let b:sh_indent_options['case-statements'] = 0
let b:sh_indent_options['case-breaks'] = 0

"Non-recursive visual mode key mappings for comments.
noremap <silent> ,# :call CommentLineToEnd('# ')<CR>+
noremap <silent> ,/ :call CommentLineToEnd('// ')<CR>+
noremap <silent> ," :call CommentLineToEnd('" ')<CR>+
noremap <silent> ,; :call CommentLineToEnd('; ')<CR>+
noremap <silent> ,- :call CommentLineToEnd('-- ')<CR>+
noremap <silent> ,* :call CommentLinePincer('/* ', ' */')<CR>+
noremap <silent> ,< :call CommentLinePincer('<!-- ', ' -->')<CR>+

" Custom key mappings.
map <silent> <M-v> :vsplit<CR>
map <silent> <M-h> :split<CR>
map <silent> <M-b> :BuffersToggle!<CR>
map <silent> <M-p> :ProjectCD<CR>:cd<CR>
map <silent> <M-l> :LocateFile<CR>
map <silent> <M-r> :NERDTree<CR>
map <silent> <M-n> :NERDTreeToggle<CR>
map <silent> <M-t> :ConqueTerm bash -ls<CR>

" Settings for NERDTree.
autocmd VimEnter * silent NERDTree | wincmd p
autocmd VimEnter * NERDTreeToggle
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeIgnore=['^NTUSER\.DAT.*$']
"let g:NERDTreeDirArrowExpandable = '→'
"let g:NERDTreeDirArrowCollapsible = '↓'
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✓",
    \ "Unknown"   : "?"
    \ }

" Settings for syntastic.
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Settings for Eclim.
let g:EclimCompletionMethod = 'omnifunc'
let g:EclimBuffersDefaultAction = 'edit'
let g:EclimLocateFileDefaultAction = 'edit'

" Settings for Airline.
let g:airline_powerline_fonts = 1

" Settings for ConqueTerm.
let g:ConqueTerm_StartMessages = 0

" Fullscreen enablement for Windows gvim.
map <M-f> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>

" Toggle distraction free mode in gvim.
map <M-d> <Esc>:call ToggleDistractionFree()<cr>
function! ToggleDistractionFree()
    let l:menu_option = strridx(&guioptions, "m")
    let l:toolbar_option = strridx(&guioptions, "T")
    let l:scrollbar_left_option = strridx(&guioptions, "L")
    let l:scrollbar_right_option = strridx(&guioptions, "r")
    if l:menu_option > 0
        set guioptions-=m
    else
        set guioptions+=m
    endif
    if l:toolbar_option > 0
        set guioptions-=T
    else
        set guioptions+=T
    endif
    if l:scrollbar_left_option > 0
        set guioptions-=L
    else
        set guioptions+=L
    endif
    if l:scrollbar_right_option > 0
        set guioptions-=r
    else
        set guioptions+=r
    endif
endfunction
call ToggleDistractionFree()
