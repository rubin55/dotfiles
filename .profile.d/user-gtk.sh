#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which gtk-launch || return

# Set GDK_BACKEND.
case "$XDG_SESSION_TYPE" in
  tty|x11)
  export GDK_BACKEND=x11
  ;;
  wayland)
  export GDK_BACKEND=wayland,x11
  ;;
  *)
  export GDK_BACKEND=x11
  ;;
esac

# Set GDK_USE_XFT.
export GDK_USE_XFT=1
