#!/bin/bash

platform=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$(uname -r)" =~ "icrosoft" ]] && platform=windows


if [ "$platform" == "linux" ]; then
    PYTHON_EXEC=$(which python3 2> /dev/null)
    if [ ! -z "$PYTHON_EXEC" ]; then
        #alias python='python3'
        #alias pip='pip-linux.sh'
        alias venv="$PYTHON_EXEC -m venv"

        PYTHON_VERSION=$("$PYTHON_EXEC" -V | awk '{print $2}')

        # Used by custom pip-linux.sh.
        export PYTHON_LOCAL_HOME=$HOME/.python/$PYTHON_VERSION

        # Add PYTHON_LOCAL_HOME/bin to path if not in path already.
        if [[ ":$PATH:" != *":$PYTHON_LOCAL_HOME/bin:"* ]]; then
            export PATH="${PATH:+"$PATH:"}$PYTHON_LOCAL_HOME/bin"
        fi
    fi
fi

if [ "$platform" == "darwin" ]; then

    # Prefer Python 3.x if it's installed, else fall back on
    # the ancient system-provided 2.7 version.
    PYTHON_EXEC="/Library/Frameworks/Python.framework/Versions/Current/bin/python3"
    if [ -x "$PYTHON_EXEC" ]; then
        PYTHON_VERSION="$($PYTHON_EXEC -c 'import sys; print(str(sys.version_info[0])+"."+str(sys.version_info[1]))')"
        PYTHON_HOME="/Library/Frameworks/Python.framework/Versions/Current"
        alias venv="python3 -m venv"
    else
        PYTHON_VERSION=2.7
        PYTHON_HOME="/usr"
    fi

    # Make sure things like pip shut up about deprecation.
    export PYTHONWARNINGS="ignore:DEPRECATION"

    PYTHON_EXEC="$PYTHON_HOME/bin/python$PYTHON_VERSION"
    if [ -x "$PYTHON_EXEC" ]; then

        # Add PYTHON_HOME/bin to path if not in path already.
        if [[ ":$PATH:" != *":$PYTHON_HOME/bin:"* ]]; then
            export PATH="$PYTHON_HOME/bin${PATH:+":$PATH"}"
        fi

        # Set PYTHON_LOCAL_HOME (where scripts are installed by pip?).
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
