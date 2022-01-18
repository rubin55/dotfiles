#!/bin/bash

# What are we running on?
platform=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$(uname -r)" =~ "icrosoft" ]] && platform=windows

# On mac or linux, simple cargo home.
if [[ "$platform" == "darwin" || "$platform" == "linux" ]]; then
    CARGO_HOME="$HOME/.cargo"

    # If we have rustup with env, set up rust using rustup.
    [[ -s "$CARGO_HOME/env" ]] && source "$CARGO_HOME/env"

    RUST_EXEC=$(which rustc 2> /dev/null)
    if [ ! -z "$RUST_EXEC" ]; then

        # Add ~/.cargo/bin to path if not in path already.
        if [[ ":$PATH:" != *":$CARGO_HOME/bin:"* ]]; then
            export PATH="${PATH:+"$PATH:"}$CARGO_HOME/bin"
        fi

        RUST_MAN_PATH="$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/man"
        if [[ -d "$RUST_MAN_PATH" && ":$MANPATH:" != *":$RUST_MAN_PATH:"* ]]; then
            export MANPATH="${MANPATH:+"$MANPATH:"}$RUST_MAN_PATH"
        fi

        RUST_SRC_PATH="/usr/lib64/rust-$(rustc --version | awk '{print $2}')/rustlib/src/rust/src"
        if [[ "$platform" == "linux" && -d "$RUST_SRC_PATH" ]]; then
            export RUST_SRC_PATH
        fi
    fi
fi

# On WSL it's different.
if [[ "$platform" == "windows" ]]; then
    CARGO_HOME="$(echo $HOME | sed 's|/home/|/mnt/c/Users/|g')/.cargo"

    if [[ -d "$CARGO_HOME/bin" ]]; then
        # Create aliases for all .exe in $CARGO_HOME
        cd "$CARGO_HOME/bin"
        for X in *.exe; do
            alias $(echo $X | sed 's|\.exe||g')=$X
        done
        cd - > /dev/null
    fi
fi


