#!/bin/bash

platform=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$(uname -r)" =~ "icrosoft" ]] && platform=windows


if [ "$platform" == "linux" ]; then
    if [[ "$XDG_SESSION_TYPE"  == "tty" ||  "$XDG_SESSION_TYPE"  == "x11" ]]; then
    	export MOZ_ENABLE_WAYLAND=0
    elif [[  "$XDG_SESSION_TYPE"  == "wayland" ]]; then
    	export MOZ_ENABLE_WAYLAND=1
    else
    	export MOZ_ENABLE_WAYLAND=0
    fi
fi

if [ "$platform" == "darwin" ]; then
    echo placeholder > /dev/null
fi

if [ "$platform" == "windows" ]; then
    echo placeholder > /dev/null
fi
