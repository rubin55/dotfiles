#!/bin/bash

runSyncthing() {
    local platform=$(uname -s | tr '[:upper:]' '[:lower:]')

    # But if it's WSL..
    if [[ "$(uname -r)" =~ "icrosoft" ]]; then
        local platform=windows
    fi

    local syncthing="$(which syncthing 2> /dev/null)"
    local running=$(pgrep -f syncthing 2> /dev/null)

    if [[ ! -z $syncthing && $platform == linux && $TERM == linux && -z $running ]]; then
        echo "Notice: Starting syncthing.."
        "$syncthing" -no-browser > "$HOME/.config/syncthing/syncthing.log" 2>&1 &
    fi
}
