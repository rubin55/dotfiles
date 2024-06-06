" Settings for vim-lsp-settings.

" Currently, vim-lsp-settings won't detect hls automatically.
if (executable('haskell-language-server-wrapper'))
  au User lsp_setup call lsp#register_server({
      \ 'name': 'haskell-language-server-wrapper',
      \ 'cmd': {server_info->['haskell-language-server-wrapper', '--lsp']},
      \ 'whitelist': ['haskell'],
      \ })
endif

" Use native LSP client in vim 9+.
let g:lsp_use_native_client = 1

" Very common shortcuts.
nnoremap gd :LspDefinition<Cr>
nnoremap gr :LspReferences<Cr>
nnoremap gR :LspRename<Cr>
nnoremap <silent> <expr> <C-k> popup_list()->empty() ? ":LspHover\<Cr>" : ":call popup_clear()\<Cr>"
inoremap <silent> <expr> <C-k> popup_list()->empty() ? "<C-o>:LspHover\<Cr>" : "<C-o>:call popup_clear()\<Cr>"

" Some common settings.
let g:lsp_preview_float = 1
let g:lsp_preview_autoclose = 1
let g:lsp_document_code_action_signs_enabled = 0

" Dealing with diagnostic windows.
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_float_cursor = 0
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_virtual_text_align = "right"

" Customize the signs gutter.
let g:lsp_diagnostics_signs_information = {'text': '☼'}
let g:lsp_diagnostics_signs_warning = {'text': '⚠'}
let g:lsp_diagnostics_signs_error =  {'text': '✗'}
let g:lsp_diagnostics_signs_hint = {'text': '♬'}

" Make sure we use no background color for signs column.
highlight clear SignColumn
