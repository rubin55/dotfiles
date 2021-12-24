" Settings for NERDTree.
if exists('g:loaded_nerdtree')
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
