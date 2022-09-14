#!/bin/bash

function addManPaths() {
    NVM_DEFAULT_ALIAS="$HOME/.nvm/alias/default"
    if [ -e "$NVM_DEFAULT_ALIAS" ]; then
        NODE_VERSION=$(cat "$NVM_DEFAULT_ALIAS")
    else
        NODE_VERSION=$(node --version)
    fi

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

        # Add man pages to manpath.
        addManPaths
    fi
fi

