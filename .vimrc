" Turn off compatible mode.
set nocompatible

" VimPlug section.
call plug#begin('~/.vim/plugged')
Plug 'arcticicestudio/nord-vim'
Plug 'chriskempson/base16-vim'
Plug 'morhetz/gruvbox'
Plug 'myint/syntastic-extras'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'sirver/UltiSnips'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'wkentaro/conque.vim'
Plug 'Shougo/unite.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Fyrbll/intero-vim'
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

" Set color scheme for terminal.
colorscheme default

" Enable line-numbers.
set number

" Settings for gvim.
if has('gui_running')
  colorscheme gruvbox
  set lines=40 columns=120
  if has('gui_gtk2')
    set guifont=Hack\ 11
  elseif has('gui_macvim')
    set guifont=PragmataPro\ Mono\ Liga:h16
    " set macligatures
    set macmeta
    set guioptions+=T
  elseif has('gui_win32')
    set guifont=Consolas:h10
  endif
endif

" Go to last visited line on open.
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

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
if !exists('b:sh_indent_options')
  let b:sh_indent_options = {}
endif
let b:sh_indent_options['case-statements'] = 0
let b:sh_indent_options['case-breaks'] = 0

"Non-recursive visual mode key mappings for comments.
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

" Vertical and horizontal split window.
map <silent> <M-v> :vsplit<Cr>
map <silent> <M-h> :split<Cr>

" Settings for Conque.
map <silent> <M-c> :ConqueTerm cmd.exe<Cr>

" Settings for Unite.
map <silent> <M-f> :Unite -resume -no-split -buffer-name=files -start-insert file<cr>
map <silent> <M-r> :Unite -resume -no-split -buffer-name=recursive -start-insert file_rec<cr>
map <silent> <M-b> :Unite -resume -no-split -buffer-name=buffer buffer<Cr>
call unite#filters#matcher_default#use(['matcher_fuzzy'])
autocmd FileType unite call s:unite_keymaps()
function! s:unite_keymaps()
    map <buffer> <Esc>   <Plug>(unite_exit)
endfunction`

" Settings for NERDTree.
map <silent> <M-n> :NERDTreeToggle<Cr>
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
    \ 'Modified'  : '✹',
    \ 'Staged'    : '✚',
    \ 'Untracked' : '✭',
    \ 'Renamed'   : '➜',
    \ 'Unmerged'  : '═',
    \ 'Deleted'   : '✖',
    \ 'Dirty'     : '✗',
    \ 'Clean'     : '✓',
    \ 'Unknown'   : '?'
    \ }

" Settings for Syntastic.
map <silent> <M-s> :SyntasticCheck<Cr> :SyntasticToggleMode<Cr>
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_java_checkers = []
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }

" Settings for Airline.
let g:airline_theme = 'base16color'
let g:airline_powerline_fonts = 1

" Settings for ConqueTerm.
let g:ConqueTerm_StartMessages = 0

" Settings for UltiSnips.
nmap <silent> <M-u> :UltiSnipsEdit<Cr>
let g:UltiSnipsUsePythonVersion = 2
if has('unix')
    let g:UltiSnipsSnippetsDir = '/home/rubin/.vim/snippets'
    let g:UltiSnipsSnippetDirectories=['/home/rubin/VimFiles/snippets']
elseif has('win32')
    let g:UltiSnipsSnippetsDir = 'C:/Users/rubin/.vim/snippets'
    let g:UltiSnipsSnippetDirectories=['C:/Users/rubin/VimFiles/snippets']
endif
let g:UltiSnipsEnableSnipMate = 0
let g:UltiSnipsListSnippets = '<M-u>'
let g:UltiSnipsEditSplit= 'vertical'

" Settings for YouCompleteMe.
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['Up']
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_filetype_blacklist = {
      \ 'html' : 1,
      \ 'infolog' : 1,
      \ 'mail' : 1,
      \ 'markdown' : 1,
      \ 'notes' : 1,
      \ 'pandoc' : 1,
      \ 'pom' : 1,
      \ 'qf' : 1,
      \ 'tagbar' : 1,
      \ 'text' : 1,
      \ 'unite' : 1,
      \ 'vimwiki' : 1,
      \ 'xml' : 1
      \}


" Fullscreen enablement for Windows or Mac gvim.
"map <F11> <Esc>:call libcallnr('gvimfullscreen.dll', 'ToggleFullScreen', 0)<Cr>
map <F11> :set invfu

" Toggle distraction free mode in gvim.
map <M-d> <Esc>:call ToggleDistractionFree()<cr>
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
call ToggleDistractionFree()

