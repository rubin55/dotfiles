#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which vbccm68k,sed || return

# Set VBCC home.
export VBCC="$(which vbccm68k | sed 's#/bin/vbccm68k##g')"

