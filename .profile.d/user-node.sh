#!/bin/bash

# If we have nvm.sh, set up node  using ghcup.
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  source "$HOME/.nvm/nvm.sh"

  # Add manpath too.
  if path.which node; then
    NODE_VERSION=$(node --version)
    MANPATH_NEW="$HOME/.nvm/versions/node/$NODE_VERSION/share/man:$HOME/.nvm/versions/node/$NODE_VERSION/lib/node_modules/npm/man"
    export MANPATH=":$(path.append "$MANPATH_NEW" "$MANPATH")"
  fi
fi

# Configure NPM prefix.
if path.which node,npm; then
  NODE_VERSION="$(node --version)"
  NPM_CURRENT_PREFIX="$(npm config get prefix)"
  if [[ "$NPM_CURRENT_PREFIX" != *"$HOME"* ]]; then
    npm config set prefix $HOME/.node/$NODE_VERSION
    mkdir -p "$HOME/.node/$NODE_VERSION/bin"
  fi

  # Add NPM_CURRENT_PREFIX/bin to path if not in path already.
  export PATH=$(path.append "$HOME/.node/$NODE_VERSION/bin" "$PATH")
fi
