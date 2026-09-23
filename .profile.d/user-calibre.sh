#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p env.persist path.which || return
path.which calibre || return

# Use the qt6ct style, so calibre follows light and dark mode.
env.persist calibre CALIBRE_USE_SYSTEM_THEME 1
