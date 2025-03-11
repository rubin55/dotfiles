#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which qt6ct || return

# Set QT_QPA_PLATFORM.
case "$XDG_SESSION_TYPE" in
  tty|x11)
  export QT_QPA_PLATFORM=xcb
  ;;
  wayland)
  export QT_QPA_PLATFORM=wayland
  ;;
  *)
  export QT_QPA_PLATFORM=xcb
  ;;
esac

# Set various other QT environment variables.
export QT_ACCESSIBILITY=0
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_LINUX_ACCESSIBILITY_ALWAYS_ON=0
export QT_QPA_PLATFORMTHEME=gnome
export QT_XFT=true
