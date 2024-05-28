let g:fzf_vim = {}
let g:fzf_layout = { 'down': '~33%' }

" Customize fzf colors to match your color scheme
" fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Various settings and key-bindings for fzf.
nnoremap <C-b> :Buffers<Cr>
nnoremap <C-p> :GFiles<Cr>
nnoremap <C-g> :Ag<Cr>

" Make sure Esc to exit works and hide statusline.
autocmd! FileType fzf execute 'tunmap <Esc>' | set laststatus=0 noshowmode noruler | autocmd BufLeave <buffer> set laststatus=2 showmode ruler

