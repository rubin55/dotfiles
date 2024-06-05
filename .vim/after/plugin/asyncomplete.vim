" Settings for asyncomplete.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <Cr>    pumvisible() ? asyncomplete#close_popup() : "\<Cr>"
imap <C-Space> <Plug>(asyncomplete_force_refresh)
