#!/bin/bash

# What to do.
SET_PATH=true
SET_ALIAS=false

# Application locations, alias names, etc.
CFG_ALIAS="hla"
CFG_EXEC_UNIX="/opt/hla/hla2/hla"
CFG_EXEC_MACOS=""
CFG_EXEC_WINDOWS=""

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
fi

# If application was found and alias setting enabled, set some aliases.
if [[ "$SET_ALIAS" == true && "$APP_BINARY" != "not-found" ]]; then
    alias "$CFG_ALIAS"="$(echo $APP_BINARY | sed -e 's| |\\ |g' -e 's|(|\\(|g' -e 's|)|\\)|g')"
fi

# If application was found, set a few environment variables.
if [[ "$APP_BINDIR" != "not-found" ]]; then
    hladir="$APP_BINDIR"
    hlainc="$hladir/include"
    hlalib="$hladir/hlalib"
    hlatemp="/tmp"
    export hlainc hlalib hlatmp
fi
