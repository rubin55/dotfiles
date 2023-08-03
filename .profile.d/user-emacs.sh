#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.append path.which || return
path.which emacs || return

if [[ -d "$HOME/.emacs.d/bin" ]]; then
  export PATH=$(path.append "$HOME/.emacs.d/bin" "$PATH")
fi

