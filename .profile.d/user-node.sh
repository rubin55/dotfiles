#!/bin/bash

# If we have nvm, set up node using nvm.
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
[[ -s "$HOME/.nvm/nvm.sh" ]] && nvm use default > /dev/null

# A few helpful variables.
[[ $(which node 2>/dev/null) ]] && NODE_EXEC=$(which node 2>/dev/null) && alias node="$(echo $NODE_EXEC | sed -e 's| |\\ |g' -e 's|(|\\(|g' -e 's|)|\\)|g')"
[[ $(which node.exe 2>/dev/null) ]] && NODE_EXEC=$(which node.exe 2>/dev/null) && alias node="$(echo $NODE_EXEC | sed -e 's| |\\ |g' -e 's|(|\\(|g' -e 's|)|\\)|g')"

if [[ -n "$NODE_EXEC" ]]; then
    NODE_VERSION=$("$NODE_EXEC" --version | sed 's/^v//')

    [[ $(which npm 2>/dev/null) ]] && NPM_EXEC=$(which npm 2>/dev/null) && alias npm=$NPM_EXEC

    if [[ ! -z "$(which npm.cmd 2>/dev/null)" ]]; then
        NPM_EXEC="cmd.exe /c npm.cmd"
        alias npm=$NPM_EXEC
    elif [[ ! -z "$NPM_EXEC" ]]; then
        NPM_CURRENT_PREFIX="$($NPM_EXEC config get prefix)"
        if [[ "$NPM_CURRENT_PREFIX" != *"$HOME"* ]]; then
            "$NPM_EXEC" config set prefix $HOME/.node/$NODE_VERSION
        fi
    fi

    # Add NPM_CURRENT_PREFIX/bin to path if not in path already.
    if [[ ":$PATH:" != *":$NPM_CURRENT_PREFIX/bin:"* ]]; then
        export PATH="${PATH:+"$PATH:"}$NPM_CURRENT_PREFIX/bin"
    fi
fi

