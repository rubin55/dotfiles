" Settings for Airline.
if exists('g:loaded_airline')
    let g:airline_theme = 'atomic'
    let g:airline_powerline_fonts = 1

    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif

    " Extensions.
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#formatter = 'unique_tail'

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
