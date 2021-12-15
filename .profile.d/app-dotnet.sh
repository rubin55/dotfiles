#!/bin/bash

# What to do.
SET_PATH=true
SET_ALIAS=false

# Application locations, alias names, etc.
CFG_ALIAS="dotnet"
CFG_EXEC_UNIX="/opt/dotnet/dotnet6/dotnet"
CFG_EXEC_MACOS="$HOME/Applications/DotNet/dotnet6/dotnet"
CFG_EXEC_WINDOWS="/mnt/c/Program Files/dotnet/dotnet.exe"

# Determine application home.
if [ -x "$CFG_EXEC_UNIX" ]; then
    APP_BINARY="$CFG_EXEC_UNIX"
    APP_BINDIR="$(dirname "$CFG_EXEC_UNIX")"
    APP_USRDIR="$HOME/.dotnet/tools"
elif [ -x "$CFG_EXEC_MACOS" ]; then
    APP_BINARY="$CFG_EXEC_MACOS"
    APP_BINDIR="$(dirname "$CFG_EXEC_MACOS")"
    APP_USRDIR="$HOME/.dotnet/tools"
elif [ -x "$CFG_EXEC_WINDOWS" ]; then
    APP_BINARY="$CFG_EXEC_WINDOWS"
    APP_BINDIR="$(dirname "$CFG_EXEC_WINDOWS")"
    APP_USRDIR="$HOME/.dotnet/tools"
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

# Add user tools directory to path if it exists.
if [[ -d "$APP_USRDIR" ]]; then
    if [[ ":$PATH:" != *":$APP_USRDIR:"* ]]; then
        export PATH="${PATH:+"$PATH:"}$APP_USRDIR"
    fi
fi

# If application was found and alias setting enabled, set some aliases.
if [[ "$SET_ALIAS" == true && "$APP_BINARY" != "not-found" ]]; then
    alias "$CFG_ALIAS"="$(echo $APP_BINARY | sed -e 's| |\\ |g' -e 's|(|\\(|g' -e 's|)|\\)|g')"
fi

# Make sure dotnet knows where home is.
export DOTNET_ROOT=$APP_BINDIR
