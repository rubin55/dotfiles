#!/bin/bash

# Check if functions are loaded.
type -p path.append path.which || return

# If we have rustup with env, set up rust using rustup.
[[ -s "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

if path.which rustc; then
  # Add ~/.cargo/bin to path if not in path already.
  export PATH=$(path.append "$HOME/.cargo/bin" "$PATH")

  MANPATH_NEW=$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/man
  # Add manpath (prefixed ':' is intentional, see man manpath).
  export MANPATH=":$(path.append "$MANPATH_NEW" "$MANPATH")"
fi
