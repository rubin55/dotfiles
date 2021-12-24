" Settings for asyncomplete.
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <Cr>    pumvisible() ? asyncomplete#close_popup() : "\<Cr>"
