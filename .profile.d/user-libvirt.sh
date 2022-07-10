#!/bin/bash
shopt -s compat31
isNumber='^[0-9]+$'
if [[ "$(uname -s)" == "Linux" && "$(pgrep libvirtd)" =~ "$isNumber" ]]; then
    export LIBVIRT_DEFAULT_URI=qemu:///system
fi
