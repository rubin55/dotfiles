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

# Configure NPM prefix to ~/.node if .npmrc doesn't already set one.
if path.which node,npm; then
  NODE_PREFIX=""
  if [[ -e "$HOME/.npmrc" ]]; then
    while IFS= read -r line; do
      if [[ "$line" =~ ^[[:space:]]*prefix[[:space:]]*=[[:space:]]*(.*)$ ]]; then
        NODE_PREFIX="${BASH_REMATCH[1]}"
        NODE_PREFIX="${NODE_PREFIX/#\~/$HOME}"
        break
      fi
    done < "$HOME/.npmrc"
  fi
  if [[ -z "$NODE_PREFIX" ]]; then
    NODE_PREFIX="$HOME/.node"
    npm config set prefix "$NODE_PREFIX"
    mkdir -p "$NODE_PREFIX/bin"
  fi
  export PATH="$(path.append "$NODE_PREFIX/bin" "$PATH")"
fi

# Unset temporary variables.
unset NODE_VERSION MANPATH_NEW NODE_PREFIX line
