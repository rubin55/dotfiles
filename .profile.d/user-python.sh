#!/bin/bash

platform=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$(uname -r)" =~ "Microsoft" ]] && platform=windows


if [ "$platform" == "linux" ]; then
    PYTHON_EXEC=$(which python3 2> /dev/null)
    if [ ! -z "$PYTHON_EXEC" ]; then
        alias python='python3'
        alias pip='pip-linux.sh'

        PYTHON_VERSION=$(python -V | awk '{print $2}')

        # Used by custom pip-linux.sh.
        export PYTHON_LOCAL_HOME=$HOME/.python/$PYTHON_VERSION

        # Add PYTHON_LOCAL_HOME/bin to path if not in path already.
        if [[ ":$PATH:" != *":$PYTHON_LOCAL_HOME/bin:"* ]]; then
            export PATH="${PATH:+"$PATH:"}$PYTHON_LOCAL_HOME/bin"
        fi
    fi
fi

if [ "$platform" == "darwin" ]; then
    PYTHON_EXEC=$(which python 2> /dev/null)
    if [ ! -z "$PYTHON_EXEC" ]; then
        alias pip='pip-mac.sh'

        # Used by custom pip-linux.sh.
        export PYTHON_LOCAL_HOME=$HOME/Library/Python/2.7/bin

        # Add PYTHON_LOCAL_HOME/bin to path if not in path already.
        if [[ ":$PATH:" != *":$PYTHON_LOCAL_HOME/bin:"* ]]; then
            export PATH="${PATH:+"$PATH:"}$PYTHON_LOCAL_HOME/bin"
        fi
    fi
fi

if [ "$platform" == "windows" ]; then
    PYTHON_EXEC=$(which python.exe 2> /dev/null)
    if [ ! -z "$PYTHON_EXEC" ]; then
        alias python='python.exe'
        alias pip='pip-linux.sh'

        PYTHON_VERSION=$(python -V | awk '{print $2}')

        # Used by custom pip-linux.sh.
        export PYTHON_LOCAL_HOME=$(echo $HOME | sed 's|/home/|/mnt/c/Users/|g')/.python/$PYTHON_VERSION

        # Add PYTHON_LOCAL_HOME/bin to path if not in path already.
        if [[ ":$PATH:" != *":$PYTHON_LOCAL_HOME/bin:"* ]]; then
            export PATH="${PATH:+"$PATH:"}$PYTHON_LOCAL_HOME/bin"
        fi
    fi
fi