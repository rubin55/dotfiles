#!/bin/bash

platform=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$(uname -r)" =~ "icrosoft" ]] && platform=windows


if [ "$platform" == "linux" ]; then
    PYTHON_EXEC=$(which python3 2> /dev/null)
    if [ ! -z "$PYTHON_EXEC" ]; then
        #alias python='python3'
        #alias pip='pip-linux.sh'
        alias venv="python3 -m venv"

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

    # Prefer Python 3.8 if it's installed, else fall back on
    # the ancient system-provided 2.7 version.
    if [ -x "/Library/Frameworks/Python.framework/Versions/3.8/bin/python3.8" ]; then
        PYTHON_VERSION=3.8
        PYTHON_HOME="/Library/Frameworks/Python.framework/Versions/$PYTHON_VERSION"
        #alias pip="pip-mac3.sh"
        alias venv="python3 -m venv"
    else
        PYTHON_VERSION=2.7
        PYTHON_HOME="/usr"
        #alias pip="pip-mac2.sh"
    fi

    PYTHON_EXEC="$PYTHON_HOME/bin/python$PYTHON_VERSION"
    if [ ! -z "$PYTHON_EXEC" ]; then
        #alias python="$PYTHON_EXEC"

        # Add PYTHON_HOME/bin to path if not in path already.
        if [[ ":$PATH:" != *":$PYTHON_HOME/bin:"* ]]; then
            export PATH="$PYTHON_HOME/bin${PATH:+":$PATH"}"
        fi

        # Used by custom pip-mac.sh.
        PYTHON_LOCAL_HOME="$HOME/Library/Python/$PYTHON_VERSION"

        # Add PYTHON_LOCAL_HOME/bin to path if not in path already.
        if [[ ":$PATH:" != *":$PYTHON_LOCAL_HOME/bin:"* ]]; then
            export PATH="${PATH:+"$PATH:"}$PYTHON_LOCAL_HOME/bin"
        fi
    fi
fi

if [ "$platform" == "windows" ]; then
    PYTHON_EXEC=$(which python3 2> /dev/null)
    if [ ! -z "$PYTHON_EXEC" ]; then
        #alias python='python3'
        #alias pip='pip-linux.sh'
        alias venv="python3 -m venv"

        PYTHON_VERSION=$(python3 -V | awk '{print $2}')

        # Used by custom pip-linux.sh.
        export PYTHON_LOCAL_HOME=$(echo $HOME | sed 's|/home/|/mnt/c/Users/|g')/.python/$PYTHON_VERSION

        # Add PYTHON_LOCAL_HOME/bin to path if not in path already.
        if [[ ":$PATH:" != *":$PYTHON_LOCAL_HOME/bin:"* ]]; then
            export PATH="${PATH:+"$PATH:"}$PYTHON_LOCAL_HOME/bin"
        fi
    fi
fi
