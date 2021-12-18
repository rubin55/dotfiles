" Check if plugin is loaded function.
function! PlugLoaded(name)
    return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir) &&
        \ stridx(&rtp, g:plugs[a:name].dir) >= 0)
endfunction

" Turn off compatible mode.
set nocompatible

" Turn off modeline support.
set nomodeline

" VimPlug section.
call plug#begin('~/.vim/plugged')
"Plug 'arcticicestudio/nord-vim'
"Plug 'chriskempson/base16-vim'
"Plug 'fatih/vim-go'
Plug 'jamessan/vim-gnupg', { 'branch': 'main' }
"Plug 'lighttiger2505/deoplete-vim-lsp'
"Plug 'mattn/vim-lsp-settings'
Plug 'mechatroner/rainbow_csv'
"Plug 'morhetz/gruvbox'
"Plug 'myint/syntastic-extras'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'roxma/nvim-yarp'
"Plug 'roxma/vim-hug-neovim-rpc'
"Plug 'scrooloose/nerdtree'
"Plug 'scrooloose/syntastic'
"Plug 'sirver/UltiSnips'
"Plug 'tpope/vim-fireplace'
"Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'Shougo/deol.nvim'
"Plug 'Shougo/unite.vim'
"Plug 'Shougo/deoplete.nvim'
"Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'Fyrbll/intero-vim'
Plug 'sainnhe/everforest'
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
" colorscheme default

" Enable line-numbers.
set number

" Settings for gvim.
if has('gui_running')
  colorscheme everforest
  set lines=40 columns=120
  if has('gui_gtk3')
    set guifont=PragmataPro\ Mono\ 14
  elseif has('gui_macvim')
    set guifont=PragmataPro\ Mono:h16
    set macligatures
    set macmeta
    set guioptions+=T
  elseif has('gui_win32')
    set guifont=PragmataPro\ Mono:h11
  endif
endif

" Silence vim.
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Go to last visited line on open.
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Don't do spaces for tabs in makefiles, tab-separated files.
au FileType make set noexpandtab
au FileType tsv set noexpandtab

" Set a wider tabstop for tab-separated files.
au FileType tsv set tabstop=24

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

" Deol.nvim terminal.
if PlugLoaded('deol.nvim')
    tnoremap <ESC> <C-\><C-n>
    map <silent> <M-c> :Deol<Cr>
endif

" Settings for Unite.
if PlugLoaded('unite.vim')
    map <silent> <M-f> :Unite -resume -no-split -buffer-name=files -start-insert file<cr>
    map <silent> <M-r> :Unite -resume -no-split -buffer-name=recursive -start-insert file_rec<cr>
    map <silent> <M-b> :Unite -resume -no-split -buffer-name=buffer buffer<Cr>
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    autocmd FileType unite call s:unite_keymaps()
    function! s:unite_keymaps()
        map <buffer> <Esc>   <Plug>(unite_exit)
    endfunction`
endif

" Settings for NERDTree.
if PlugLoaded('nerdtree')
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
    let g:NERDTreeGitStatusIndicatorMapCustom = {
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
endif

" Settings for Syntastic.
if PlugLoaded('syntastic')
    map <silent> <M-s> :SyntasticCheck<Cr> :SyntasticToggleMode<Cr>
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_java_checkers = []
    let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
endif

" Settings for Airline.
if PlugLoaded('vim-airline')
    if has('gui_running')
        let g:airline_theme = 'everforest'
    else
        let g:airline_theme = 'base16_oceanicnext'
    endif
    let g:airline_powerline_fonts = 1

    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif

    " Airline symbols.
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.colnr = ' c'
    let g:airline_symbols.linenr = ' l'
    let g:airline_symbols.maxlinenr = ' '
endif

" Settings for UltiSnips.
if PlugLoaded('UltiSnips')
    nmap <silent> <M-u> :UltiSnipsEdit<Cr>
    let g:UltiSnipsUsePythonVersion = 3
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
endif

" Settings for deoplete.
if PlugLoaded('deoplete.nvim')
    let g:deoplete#enable_at_startup = 1
endif

" Fullscreen enablement for Windows, Mac or Linux gvim.
"map <F11> <Esc>:call libcallnr('gvimfullscreen.dll', 'ToggleFullScreen', 0)<Cr>
"map <F11> :set invfu<Cr>
map <F11> <Esc>:call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<Cr><Cr>

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
call ToggleDistractionFree()

" Enable the menu though.
"set guioptions+=m

