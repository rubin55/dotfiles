#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p env.persist path.which || return
path.which racket || return

env.persist racket PLT_DISPLAY_BACKING_SCALE 1
