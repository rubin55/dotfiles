#!/bin/bash

if path.which cargo,rustc; then
  CARGO_HOME="$HOME/.cargo"

  # If we have rustup with env, set up rust using rustup.
  [[ -s "$CARGO_HOME/env" ]] && source "$CARGO_HOME/env"

  if path.which rustc; then
    # Add ~/.cargo/bin to path if not in path already.
    export PATH=$(path.append "$CARGO_HOME/bin" "$PATH")
  fi

  MANPATH_NEW=$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/man
  # Add manpath (prefixed ':' is intentional, see man manpath).
  export MANPATH=":$(path.append "$MANPATH_NEW" "$MANPATH")"
fi
