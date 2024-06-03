function! custom#before() abort
  set nosplitbelow
  set splitright

  if has('termguicolors')
    set termguicolors
  endif

  if has('gui_running')
    set lines=44 columns=132
    set linespace=1
  endif
endfunction

function! custom#after() abort
  set clipboard=unnamed,unnamedplus
  map <F11> <Esc>:call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<Cr><Cr>
  if !has('nvim')
    autocmd! TerminalOpen * execute 'tnoremap <Esc> <C-\><C-n>' | setlocal nonumber norelativenumber | setfiletype terminal
  endif
endfunction

