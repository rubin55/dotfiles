#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which racket || return

export PLT_DISPLAY_BACKING_SCALE=1
