#!/bin/bash

function addManPaths() {
  NODE_VERSION=$(node --version)
  MANPATH_CANDIDATES="$HOME/.nvm/versions/node/$NODE_VERSION/share/man:$HOME/.nvm/versions/node/$NODE_VERSION/lib/node_modules/npm/man"

  # Check if candidates exist, only add those.
  OLD_IFS=$IFS ; IFS=:
  for MANPATH_ELEMENT in $MANPATH_CANDIDATES; do
    if [[ -d "$MANPATH_ELEMENT" && ":$MANPATH_NEW:" != *":$MANPATH_ELEMENT:"* ]]; then
        MANPATH="${MANPATH:+"$MANPATH:"}$MANPATH_ELEMENT"
    fi
  done
  IFS=$OLD_IFS

  # Make sure we don't have empty entries.
  export MANPATH=$(echo "$MANPATH" | sed "s|::|:|g")
}

# If we have nvm, set up node using nvm, else do some manual magic.
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  source "$HOME/.nvm/nvm.sh"
  addManPaths
elif path.which node,npm; then
  NODE_MAJOR_VERSION="$(node --version | cut -d. -f1)"
  NPM_CURRENT_PREFIX="$(npm config get prefix)"
  if [[ "$NPM_CURRENT_PREFIX" != *"$HOME"* ]]; then
    npm config set prefix $HOME/.node/$NODE_MAJOR_VERSION
  fi

  # Add NPM_CURRENT_PREFIX/bin to path if not in path already.
  export PATH=$(path.append "$NPM_CURRENT_PREFIX/bin" "$PATH")

  # Add man pages to manpath.
  addManPaths
fi

