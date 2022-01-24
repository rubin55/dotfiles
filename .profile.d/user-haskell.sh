#!/bin/bash

# If we have ghcpup, set up haskell using ghcup.
if [ -f "$HOME/.ghcup/env" ]; then
    source "$HOME/.ghcup/env"

    # Add manpath for ghc too.
    GHC_MANPATH="$( echo "$(ghcup -o whereis --directory ghc)" | sed 's|/bin|/share/man|g')"
    if [[ -d "$GHC_MANPATH" && ":$MANPATH:" != *":$GHC_MANPATH:"* ]]; then
        MANPATH="${MANPATH:+"$MANPATH:"}$GHC_MANPATH"
    fi

    # Make sure we don't have empty entries.
    export MANPATH=$(echo "$MANPATH" | sed "s|::|:|g")
fi
