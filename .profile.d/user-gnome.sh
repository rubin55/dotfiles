#!/bin/bash

if [ "$(uname -s)" == "Linux" ]; then
    export GNOME_ACCESSIBILITY=0
    export NO_AT_BRIDGE=1
fi
