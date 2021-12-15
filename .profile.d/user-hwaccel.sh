#!/bin/bash

platform=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$(uname -r)" =~ "icrosoft" ]] && platform=windows


if [ "$platform" == "linux" ]; then
    export LIBVA_DRIVER_NAME=radeonsi

    export VDPAU_DRIVER=radeonsi
fi

if [ "$platform" == "darwin" ]; then
    echo placeholder > /dev/null
fi

if [ "$platform" == "windows" ]; then
    echo placeholder > /dev/null
fi
