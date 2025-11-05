#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which qt6ct || return

# Try wayland first, fallback to X11
export QT_QPA_PLATFORM="wayland;xcb"

# Set various other QT environment variables.
export QT_ACCESSIBILITY=0
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_LINUX_ACCESSIBILITY_ALWAYS_ON=0
export QT_QPA_PLATFORMTHEME=qt6ct
export QT_XFT=true
