#!/bin/bash

# If we have ghcpup, set up haskell using ghcup.
if [ -f "$HOME/.ghcup/env" ]; then
    source "$HOME/.ghcup/env"

    # Add manpath for ghc too.
    GHC_BINARY="$(which ghc 2> /dev/null)"
    if [ -x "$GHC_BINARY" ]; then
        GHC_VERSION="$(ghc --version | awk 'NF>1{print $NF}')"
        GHC_MANPATH="$HOME/.ghcup/ghc/$GHC_VERSION/share/doc/ghc-$GHC_VERSION/users_guide/build-man"
        if [ -d "$GHC_MANPATH" ]; then
            if [ ! -L "$GHC_MANPATH/man1" ]; then
                cd "$GHC_MANPATH"
                ln -s . man1
                cd - > /dev/null 2>&1
            fi
        fi

        if [[ -d "$GHC_MANPATH" && ":$MANPATH:" != *":$GHC_MANPATH:"* ]]; then
            MANPATH="${MANPATH:+"$MANPATH:"}$GHC_MANPATH"
        fi

        # Make sure we don't have empty entries.
        export MANPATH=$(echo "$MANPATH" | sed "s|::|:|g")

    fi
fi
