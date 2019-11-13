#!/bin/bash

# If we have nvm, set up node using nvm.
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
[[ -s "$HOME/.nvm/nvm.sh" ]] && nvm use default > /dev/null

# A few helpful variables.
NODE_EXEC=$(which node 2>/dev/null)
NODE_VERSION=$(node --version | sed 's/^v//')

NPM_EXEC=$(which npm 2>/dev/null)
NPM_CURRENT_PREFIX=$(npm config get prefix)

if [[ "$NPM_CURRENT_PREFIX" != *"$HOME"* ]]; then
    npm config set prefix $HOME/.node/$NODE_VERSION
fi

# Add NPM_CURRENT_PREFIX/bin to path if not in path already.
if [[ ":$PATH:" != *":$NPM_CURRENT_PREFIX/bin:"* ]]; then
    export PATH="${PATH:+"$PATH:"}$NPM_CURRENT_PREFIX/bin"
fi

