" Check if NERDTree is open or active.
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind if NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff.
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufRead * call SyncTree()

" Map NERDTree to a couple of keyboard shortcuts.
nnoremap <silent> <M-n> :bnext<CR>:call SyncTree()<CR>
nnoremap <silent> <M-p> :bprev<CR>:call SyncTree()<CR>
nnoremap <silent> <M-f> :NERDTreeToggle<cr><c-w>l:call SyncTree()<cr><c-w>h

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

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

