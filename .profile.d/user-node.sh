#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.append path.which || return
path.which mkdir || return

# If we have nvm.sh, set up node  using ghcup.
if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
  source "$HOME/.nvm/nvm.sh"

  # Figure out manpath location.
  if path.which node; then
    NODE_VERSION=$(node --version)
    MANPATH_NEW="$HOME/.nvm/versions/node/$NODE_VERSION/share/man:$HOME/.nvm/versions/node/$NODE_VERSION/lib/node_modules/npm/man"
    export MANPATH=":$(path.append "$MANPATH_NEW" "$MANPATH")"
  fi
fi

# Configure NPM prefix.
if path.which node,npm; then
  NODE_VERSION="$(node --version)"

  # The npm command is slow, only do this if we have no .npmrc.
  if [[ ! -e "$HOME/.npmrc" ]]; then
    NPM_CURRENT_PREFIX="$(npm config get prefix)"
    if [[ "$NPM_CURRENT_PREFIX" != *"$HOME"* ]]; then
      npm config set prefix $HOME/.node/$NODE_VERSION
      mkdir -p "$HOME/.node/$NODE_VERSION/bin"
    fi
  fi

  # Add NPM_CURRENT_PREFIX/bin to path if not in path already.
  export PATH=$(path.append "$HOME/.node/$NODE_VERSION/bin" "$PATH")
fi

# Unset temporary variables.
unset NODE_VERSION NPM_CURRENT_PREFIX MANPATH_NEW
