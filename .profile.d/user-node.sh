#!/bin/bash

# If we have nvm, set up node using nvm, else do some manual magic.
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    source "$HOME/.nvm/nvm.sh"
else
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
fi

# Disable TLS_VERIFICATION in certain conditions.
if [[ "$SESSION_MANAGER" =~ "picard" ]]; then
    echo "Notice: Running on Picard, disabling TLS verification for Node.."
    export NODE_TLS_REJECT_UNAUTHORIZED=0
fi
