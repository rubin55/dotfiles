" Settings for Unite.
if exists('g:loaded_unite')
    map <silent> <M-f> :Unite -resume -no-split -buffer-name=files -start-insert file<cr>
    map <silent> <M-r> :Unite -resume -no-split -buffer-name=recursive -start-insert file_rec<cr>
    map <silent> <M-b> :Unite -resume -no-split -buffer-name=buffer buffer<Cr>
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    autocmd FileType unite call s:unite_keymaps()
    function! s:unite_keymaps()
        map <buffer> <Esc>   <Plug>(unite_exit)
    endfunction
endif
