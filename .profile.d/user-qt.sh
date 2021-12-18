#!/bin/bash

if [ "$(uname -s)" == "Linux" ]; then
    if [ "$XDG_SESSION_TYPE" == "x11" ]; then
        export QT_QPA_PLATFORM=xcb
    elif [ "$XDG_SESSION_TYPE" == "wayland" ]; then
        export QT_QPA_PLATFORM=wayland
    fi
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_QPA_PLATFORMTHEME=qt5ct
    #export QT_STYLE_OVERRIDE=''
    export QT_XFT=true
    export QT_ACCESSIBILITY=0
    export QT_LINUX_ACCESSIBILITY_ALWAYS_ON=0
fi
