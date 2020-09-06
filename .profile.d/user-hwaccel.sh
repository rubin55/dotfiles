#!/bin/bash

platform=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$(uname -r)" =~ "icrosoft" ]] && platform=windows


if [ "$platform" == "linux" ]; then
    export VDPAU_DRIVER=r300
fi

if [ "$platform" == "darwin" ]; then
    echo placeholder > /dev/null
fi

if [ "$platform" == "windows" ]; then
    echo placeholder > /dev/null
fi
