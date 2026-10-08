#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p env.persist path.which || return
path.which qt6ct || return

# Try wayland first, fallback to X11.
env.persist qt QT_QPA_PLATFORM "wayland;xcb"

# Use qt5ct and qt6ct for Qt 5 and Qt 6 apps.
env.persist qt QT_QPA_PLATFORMTHEME qt6ct

# Use QAdwaitaDecorations for Qt 5 and Qt 6 window decorations.
env.persist qt QT_WAYLAND_DECORATION qadwaitadecorations

# Make sure QT applications regardless of IsEnabled can show their trees.
env.persist qt QT_LINUX_ACCESSIBILITY_ALWAYS_ON 1 
