#!/bin/bash

runSway() {
    local platform=$(uname -s | tr '[:upper:]' '[:lower:]')

    # But if it's WSL..
    if [[ "$(uname -r)" =~ "icrosoft" ]]; then
       local platform=windows
    fi

    local sway="$(which sway)"
    local running=$(pgrep -f sway)

    if [[ $platform == linux && $TERM == linux && -z $running ]]; then
        echo "Notice: Starting sway.."
        if test -z "${XDG_RUNTIME_DIR}"; then
            export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
            if ! test -d "${XDG_RUNTIME_DIR}"; then
                mkdir "${XDG_RUNTIME_DIR}"
                chmod 0700 "${XDG_RUNTIME_DIR}"
            fi
        fi

        "$sway" > "$HOME/.config/sway/sway.log" 2>&1 &
    fi
}
