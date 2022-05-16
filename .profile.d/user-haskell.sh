#!/bin/bash

# If we have ghcpup, set up haskell using ghcup.
if [ -f "$HOME/.ghcup/env" ]; then
    source "$HOME/.ghcup/env"

    # Add manpath for ghc too.
    GHC_BINARY="$(which ghc 2> /dev/null)"
    if [ -x "$GHC_BINARY" ]; then
        GHC_VERSION="$(ghc --version | awk 'NF>1{print $NF}')"
        GHC_MANPATH="$(echo "$(ghcup -o whereis --directory ghc $GHC_VERSION)" | sed 's|/bin|/share/man|g')"
        if [[ -d "$GHC_MANPATH" && ":$MANPATH:" != *":$GHC_MANPATH:"* ]]; then
            MANPATH="${MANPATH:+"$MANPATH:"}$GHC_MANPATH"
        fi

        # Make sure we don't have empty entries.
        export MANPATH=$(echo "$MANPATH" | sed "s|::|:|g")

    fi
fi
