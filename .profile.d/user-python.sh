#!/bin/bash

platform=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$(uname -r)" =~ "icrosoft" ]] && platform=windows


if [[ "$platform" == "linux" || "$platform" == "windows" ]]; then
    PYTHON_EXEC=$(which python3 2> /dev/null)
    if [ ! -z "$PYTHON_EXEC" ]; then
        alias venv="$PYTHON_EXEC -m venv"
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
