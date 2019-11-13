#!/bin/bash

# If we have rustup, set up go using rustup.
[[ -s "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

RUST_EXEC=$(which rustc 2> /dev/null)
if [ ! -z "$RUST_EXEC" ]; then

    # Add ~/.cargo/bin to path if not in path already.
    if [[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]]; then
        export PATH="${PATH:+"$PATH:"}$HOME/.cargo/bin"
    fi
fi
