" Settings for UltiSnips.
if exists('g:loaded_ultisnips')
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
