#!/bin/bash

if [ "$(uname -s)" == "Linux" ]; then
    if [[ "$XDG_SESSION_TYPE"  == "tty" ||  "$XDG_SESSION_TYPE"  == "x11" ]]; then
        export GDK_BACKEND=x11
    elif [[  "$XDG_SESSION_TYPE"  == "wayland" ]]; then
        export GDK_BACKEND=wayland,x11
    else
        export GDK_BACKEND=x11
    fi
    #export GDK_SCALE=1
    export GDK_USE_XFT=1
    export GTK_THEME=Adwaita:dark
    export SAL_USE_VCLPLUGIN=gtk
fi
