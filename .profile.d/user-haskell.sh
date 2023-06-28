#!/bin/bash

# If we have ghcpup, set up haskell using ghcup.
if [ -f "$HOME/.ghcup/env" ]; then
  source "$HOME/.ghcup/env"

  # Add manpath too.
  if path.which ghc; then
    GHC_VERSION="$(ghc --version | awk 'NF>1{print $NF}')"
    MANPATH_NEW="$HOME/.ghcup/ghc/$GHC_VERSION/share/doc/ghc-$GHC_VERSION/users_guide/build-man"
    if [ -d "$MANPATH_NEW" ]; then
      if [ ! -L "$MANPATH_NEW/man1" ]; then
        cd "$MANPATH_NEW"
        ln -s . man1
        cd - > /dev/null 2>&1
      fi
    fi

    export MANPATH=":$(path.append "$MANPATH_NEW" "$MANPATH")"
  fi
fi
