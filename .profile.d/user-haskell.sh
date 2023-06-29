#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.append path.which || return
path.which awk ln || return

# If we have ghcpup, set up haskell using ghcup.
if [[ -f "$HOME/.ghcup/env" ]]; then
  source "$HOME/.ghcup/env"

  # Figure out manpath location.
  if path.which ghc; then
    GHC_VERSION="$(ghc --version | awk 'NF>1{print $NF}')"
    MANPATH_NEW="$HOME/.ghcup/ghc/$GHC_VERSION/share/doc/ghc-$GHC_VERSION/users_guide/build-man"
    if [[ -d "$MANPATH_NEW" ]]; then
      if [[ ! -L "$MANPATH_NEW/man1" ]]; then
        cd "$MANPATH_NEW"
        ln -s . man1
        cd - > /dev/null 2>&1
      fi
    fi

    # Add manpath (prefixed ':' is intentional, see man manpath).
    export MANPATH=":$(path.append "$MANPATH_NEW" "$MANPATH")"
  fi
fi
