#!/bin/bash

# What to do.
SET_PATH=true
SET_ALIAS=false

# Application locations, alias names, etc.
CFG_ALIAS="java"
CFG_EXEC_UNIX="/opt/java/default/bin/java"
CFG_EXEC_MACOS="$(x=$(/usr/libexec/java_home -v 11 2>/dev/null); if [ -x "$x" ]; then echo $x/bin/java; fi)"
CFG_EXEC_WINDOWS="/mnt/c/Program Files/Java/adopt-jdk8/bin/java.exe"

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
    JAVA_HOME=$(dirname "$APP_BINDIR")
    export JAVA_HOME
fi
