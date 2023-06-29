#!/bin/bash

# Check if functions are loaded.
type -p path.which path.append || return

# If we have gvm, set up go using gvm.
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
[[ -s "$HOME/.gvm/scripts/gvm" ]] && gvm use go1.20 > /dev/null

# If we have go, do some stuff.
if path.which go; then
  # Set GOPATH to something better than $HOME/go.
  export GOPATH="$HOME/.go"

  # Add GOPATH/bin to path if not in path already.
  export PATH=$(path.append "$GOPATH/bin" "$PATH")
fi
