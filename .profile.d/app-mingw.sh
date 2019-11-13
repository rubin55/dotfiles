#!/bin/bash

# What to do.
SET_PATH=true
SET_ALIAS=false

# Application locations, alias names, etc.
CFG_ALIAS="mingw"
CFG_EXEC_UNIX="/opt/mingw/mingw-w64/bin/x86_64-w64-mingw32-gcc"
CFG_EXEC_MACOS="$HOME/Applications/MinGW/mingw-w64/bin/x86_64-w64-mingw32-gcc"
CFG_EXEC_WINDOWS="/mnt/c/Program files/MinGW/mingw-w64/bin/x86_64-w64-mingw32-gcc.exe"

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

    # Also add the 32-bit compiler path adjacent to the above.
    if [[ ":$PATH:" != *":$(echo "$APP_BINDIR" | sed 's|-w64|-w32|g'):"* ]]; then
        export PATH="${PATH:+"$PATH:"}$(echo "$APP_BINDIR" | sed 's|-w64|-w32|g')"
    fi
fi

# If application was found and alias setting enabled, set some aliases.
if [[ "$SET_ALIAS" == true && "$APP_BINARY" != "not-found" ]]; then
    alias "$CFG_ALIAS"="$(echo $APP_BINARY | sed -e 's| |\\ |g' -e 's|(|\\(|g' -e 's|)|\\)|g')"
fi
