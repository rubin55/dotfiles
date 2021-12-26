#!/bin/bash

if [ "$(uname -s)" == "Linux" ]; then
    # Set audio driver to use plain old alsa.
    export SDL_AUDIODRIVER=alsa

    # Set video driver based on session type.
    if [[ "$XDG_SESSION_TYPE"  == "tty" ||  "$XDG_SESSION_TYPE"  == "x11" ]]; then
        export SDL_VIDEODRIVER=x11
    elif [[  "$XDG_SESSION_TYPE"  == "wayland" ]]; then
        export SDL_VIDEODRIVER=wayland
    fi
fi
