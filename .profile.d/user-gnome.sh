#!/bin/bash

if path.which gnome-shell; then
  export GNOME_ACCESSIBILITY=0
  export NO_AT_BRIDGE=1
fi
