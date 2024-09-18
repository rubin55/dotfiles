#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.append path.which || return
path.which awk,ln || return

# If we find ghc in .ghcup/bin, we add it to the path.
# Also try to add manpath. Note, not all ghc from ghcup
# have man pages.
if path.which ghc "$HOME/.ghcup/bin"; then
  export PATH="$(path.append "$HOME/.ghcup/bin:$HOME/.cabal/bin" "$PATH")"
  GHC_VERSION="$(ghc --version | awk 'NF>1{print $NF}')"
  MANPATH_NEW="$HOME/.ghcup/ghc/$GHC_VERSION/share/doc/ghc-$GHC_VERSION/users_guide/build-man"
  if [[ -d "$MANPATH_NEW" ]]; then
    if [[ ! -L "$MANPATH_NEW/man1" ]]; then
      cd "$MANPATH_NEW"
      ln -s . man1
      cd - >/dev/null 2>&1
    fi
  fi

  # Add manpath (prefixed ':' is intentional, see man manpath).
  export MANPATH=":$(path.append "$MANPATH_NEW" "$MANPATH")"
fi

# Unset temporary variables.
unset GHC_VERSION MANPATH_NEW
