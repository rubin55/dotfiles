#!/bin/bash

if [ "$(uname -s)" == "Linux" ]; then
    #export GDK_SCALE=2
    #export GDK_USE_XFT=1
    #export SAL_USE_VCLPLUGIN=gtk
    export GDK_BACKEND=wayland
fi
