#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which firefox || return

[[ "$XDG_SESSION_TYPE" == "wayland" ]] && export MOZ_ENABLE_WAYLAND=1

