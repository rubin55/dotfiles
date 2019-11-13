#!/bin/bash

# What to do.
SET_PATH=true
SET_ALIAS=true

# Application locations, alias names, etc.
CFG_ALIAS="jprofiler"
CFG_EXEC_UNIX="/opt/jprofiler/jprofiler11/bin/jprofiler"
CFG_EXEC_MACOS="/Applications/JProfiler.app/Contents/MacOS/JavaApplicationStub"
CFG_EXEC_WINDOWS="/mnt/c/Program files/JProfiler/bin/jprofiler.exe"

# Determine application home.
if [ -x "$CFG_EXEC_UNIX" ]; then
    APP_BINARY="$CFG_EXEC_UNIX"
    APP_BINDIR="$(dirname "$CFG_EXEC_UNIX")"
elif [ -x "$CFG_EXEC_MACOS" ]; then
    APP_BINARY="$CFG_EXEC_MACOS"
    APP_BINDIR="$(dirname "$CFG_EXEC_MACOS")"
elif [ -x "$CFG_EXEC_WINDOWS" ]; then
    APP_BINARY="$CFG_EXEC_WINDOWS"
    APP_BINDIR="$(dirname "$CFG_EXEC_WINDOWS")"
else
    APP_BINARY="not-found"
    APP_BINDIR="not-found"
fi

# If application was found and path setting enabled, add to path.
if [[ "$SET_PATH" == true && "$APP_BINDIR" != "not-found" ]]; then
    if [[ ":$PATH:" != *":$APP_BINDIR:"* ]]; then
        export PATH="${PATH:+"$PATH:"}$APP_BINDIR"
    fi

    # On macOS there is an additional binary directory we'd like to have.
    if [[ "$(uname -s)" == "Darwin" ]] ; then
        if [[ ":$PATH:" != *":/Applications/JProfiler.app/Contents/Resources/app/bin:"* ]]; then
            export PATH="${PATH:+"$PATH:"}/Applications/JProfiler.app/Contents/Resources/app/bin"
        fi
    fi
fi

# If application was found and alias setting enabled, set some aliases.
if [[ "$SET_ALIAS" == true && "$APP_BINARY" != "not-found" ]]; then
    alias "$CFG_ALIAS"="$(echo $APP_BINARY | sed -e 's| |\\ |g' -e 's|(|\\(|g' -e 's|)|\\)|g')"
fi
