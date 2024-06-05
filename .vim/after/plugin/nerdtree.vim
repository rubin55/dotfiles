" Settings for NERDTree.
"
" Check if NERDTree is open or active.
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind if NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff.
function! SyncNERDTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufRead * silent call SyncNERDTree()

" Map NERDTree to a couple of keyboard shortcuts.
nnoremap <silent> <M-n> :bnext<Cr>:call SyncNERDTree()<Cr>
nnoremap <silent> <M-p> :bprev<Cr>:call SyncNERDTree()<Cr>
nnoremap <silent> <M-f> :NERDTreeToggle<Cr><C-W>l:call SyncNERDTree()<Cr><C-w>h

" Also call SyncNERDTree when alt-moving.
nnoremap <silent> <M-Up> :wincmd k<Cr>:call SyncNERDTree()<Cr>
nnoremap <silent> <M-Down> :wincmd j<Cr>:call SyncNERDTree()<Cr>
nnoremap <silent> <M-Left> :wincmd h<Cr>:call SyncNERDTree()<Cr>
nnoremap <silent> <M-Right> :wincmd l<Cr>:call SyncNERDTree()<Cr>

" Common settings for NERDTree.
let NERDTreeCaseSensitiveSort = 1
let NERDTreeNaturalSort = 1
let NERDTreeShowHidden=0
let NERDTreeMinimalUI=1
let NERDTreeShowBookmarks=0
" let NERDTreeShowLineNumbers=1
let NERDTreeWinPos="left"
let NERDTreeWinSize=30
"let g:NERDTreeDirArrowExpandable = ' '
"let g:NERDTreeDirArrowCollapsible = ' '

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | let buf=bufnr() | buffer# | execute "normal! \<C-w>w" | execute 'buffer'.buf | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | silent call feedkeys(":quit\<Cr>:\<Bs>") | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | silent call feedkeys(":quit\<Cr>:\<Bs>") | endif

" Call synctree after exiting buffers.
autocmd BufLeave * silent call SyncNERDTree()
