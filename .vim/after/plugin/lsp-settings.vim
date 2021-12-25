" Currently, vim-lsp-settings won't detect hls automatically.
if (executable('haskell-language-server-wrapper'))
  au User lsp_setup call lsp#register_server({
      \ 'name': 'haskell-language-server-wrapper',
      \ 'cmd': {server_info->['haskell-language-server-wrapper', '--lsp']},
      \ 'whitelist': ['haskell'],
      \ })
endif

" Some common settings.
let g:lsp_preview_autoclose = 0
let g:lsp_diagnostics_echo_cursor = 1
"let g:lsp_diagnostics_virtual_text_enabled = 1

" Customize the signs gutter.
let g:lsp_diagnostics_signs_information = {'text': ' ☼'}
let g:lsp_diagnostics_signs_warning = {'text': ' ⚠'}
let g:lsp_diagnostics_signs_error =  {'text': ' ✗'}
let g:lsp_diagnostics_signs_hint = {'text': ' ♬'}

" Make sure we use no background color for signs column.
highlight clear SignColumn
