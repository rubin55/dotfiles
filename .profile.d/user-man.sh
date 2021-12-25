#!/bin/bash
#
# What are we running on?
platform=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$(uname -r)" =~ "icrosoft" ]] && platform=windows

if [[ "$platform" == "linux" ]]; then
    # Default manpath.
    MANPATH="/usr/man:/usr/share/man:/usr/local/man:/usr/local/share/man:/snap/man"

    # Extra manpath.
    EXTRA_MANPATH="$(find /opt -maxdepth 5 -type d -name man | tr '\n' ':')"

    export MANPATH="$MANPATH:$EXTRA_MANPATH"
fi
