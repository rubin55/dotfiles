#!/bin/bash

if [ "$(uname -s)" == "Linux" ]; then
    export QT_QPA_PLATFORM=wayland
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_QPA_PLATFORMTHEME=qt5ct
    #export QT_STYLE_OVERRIDE=''
    export QT_XFT=true
    export QT_ACCESSIBILITY=0
    export QT_LINUX_ACCESSIBILITY_ALWAYS_ON=0
fi
