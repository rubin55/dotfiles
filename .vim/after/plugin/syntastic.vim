" Settings for Syntastic.
if exists('g:loaded_syntastic')
    map <silent> <M-s> :SyntasticCheck<Cr> :SyntasticToggleMode<Cr>
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_java_checkers = []
    let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
endif
