" Turn off compatible mode.
set nocompatible

" Turn off modeline support.
set nomodeline

" VimPlug section.
call plug#begin('~/.vim/plugged')
Plug 'jamessan/vim-gnupg', { 'branch': 'main' }
Plug 'junegunn/fzf.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'mechatroner/rainbow_csv'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'rubin55/vim-colors-github'
Plug 'sainnhe/everforest'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
call plug#end()

" Main options.
syntax on
filetype on
filetype plugin on
filetype indent on
"scriptencoding utf-8

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

" Allow modified buffers.
set hidden

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

" Enable line-numbers.
set number

" Set mouse mode.
set mouse=a

" Set background to light or dark.
set background=light

" Enable termguicolors if we have it.
if has('termguicolors')
  set termguicolors
endif

" Set color scheme.
colorscheme github

" Cursor settings.
set cursorline
set guicursor=n-v-c-i:block-Cursor
highlight Cursor guifg=lightgrey guibg=grey
highlight iCursor guifg=lightgrey guibg=grey

" Set netrw modes.
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 20

" Don't use a different background color for signs column.
" Used by at least vim-fugitive and vim-lsp.
highlight clear SignColumn

" Settings for gvim.
if has('gui_running')
  set lines=43 columns=132
  "set guioptions+=m
  if has('gui_gtk3')
    set guifont=PragmataPro\ Mono\ 10
  elseif has('gui_macvim')
    set guifont=PragmataPro\ Mono:h16
    set macligatures
    set macmeta
    set guioptions+=T
  elseif has('gui_win32')
    set guifont=PragmataPro\ Mono:h11
  endif
endif

" Work around Alt key not working in terminal.
let c='a'
while c <= 'z'
    exec "set <A-".c.">=\e".c
    exec "imap \e".c." <A-".c.">"
    let c = nr2char(1+char2nr(c))
endw
set ttimeout ttimeoutlen=50

" Silence vim.
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Go to last visited line on open.
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Don't do spaces for tabs in makefiles, tab-separated files.
au FileType make set noexpandtab
au FileType tsv set noexpandtab
au FileType conf set noexpandtab

" Set a wider tabstop for tab-separated files.
au FileType tsv set tabstop=24
au FileType conf set tabstop=24

" Disable wordwrap for certain file types.
au FileType csv set nowrap
au FileType tsv set nowrap

" Don't create a backup file for crontab edits.
au FileType crontab set nobackup

" Remove unnecessary white space on save.
autocmd BufWritePre * %s/\s\+$//e

" Highlight unnecessary white space.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/

" Extra indenting options for shell scripts.
if !exists('b:sh_indent_options')
  let b:sh_indent_options = {}
endif
let b:sh_indent_options['case-statements'] = 0
let b:sh_indent_options['case-breaks'] = 0

" Make embedded terminal use Esc to switch to normal mode.
tnoremap <Esc> <C-\><C-n>

" Non-recursive visual mode key mappings for comments.
noremap <silent> ,# :call CommentLineToEnd('# ')<Cr>+
noremap <silent> ,/ :call CommentLineToEnd('// ')<Cr>+
noremap <silent> ," :call CommentLineToEnd('" ')<Cr>+
noremap <silent> ,; :call CommentLineToEnd('; ')<Cr>+
noremap <silent> ,- :call CommentLineToEnd('-- ')<Cr>+
noremap <silent> ,* :call CommentLinePincer('/* ', ' */')<Cr>+
noremap <silent> ,< :call CommentLinePincer('<!-- ', ' -->')<Cr>+

" Navigate windows using alt-arrow-keys.
nmap <silent> <M-Up> :wincmd k<Cr>
nmap <silent> <M-Down> :wincmd j<Cr>
nmap <silent> <M-Left> :wincmd h<Cr>
nmap <silent> <M-Right> :wincmd l<Cr>

" Vertical and horizontal split key-bindings and settings.
set nosplitbelow
set splitright
map <silent> <M-v> :vsplit<Cr>
map <silent> <M-h> :split<Cr>

" Various settings and key-bindings for fzf.
nnoremap <C-b> :Buffers<Cr>
nnoremap <C-p> :GFiles<Cr>
nnoremap <C-g> :Ag<Cr>

" Fullscreen enablement for Windows, Mac or Linux gvim.
"map <F11> <Esc>:call libcallnr('gvimfullscreen.dll', 'ToggleFullScreen', 0)<Cr>
"map <F11> :set invfu<Cr>
map <F11> <Esc>:call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<Cr><Cr>

" Toggle line-ending markers.
map <M-l> <Esc>:call ToggleLineEndingMarkers()<cr>
function ToggleLineEndingMarkers()
    if &colorcolumn == ""
        set colorcolumn=80,120
    else
        set colorcolumn=
    endif
endfunction

" Toggle distraction free mode in gvim.
map <M-d> <Esc> :call ToggleDistractionFree()<cr>
function! ToggleDistractionFree()
    let l:menu_option = strridx(&guioptions, 'm')
    let l:toolbar_option = strridx(&guioptions, 'T')
    let l:scrollbar_left_option = strridx(&guioptions, 'L')
    let l:scrollbar_right_option = strridx(&guioptions, 'r')
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

" Enable distraction-free mode by default.
call ToggleDistractionFree()
