#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which gnome-shell || return

# Disable accessibility components.
export GNOME_ACCESSIBILITY=0
export NO_AT_BRIDGE=1

