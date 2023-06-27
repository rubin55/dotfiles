#!/bin/bash

# Set LIBVIRT_DEFAULT_URI when libvirtd is running.
if [[ "$(uname -s)" == "Linux" && "$(pgrep libvirtd)" =~ ^[0-9]+$ ]]; then
  export LIBVIRT_DEFAULT_URI=qemu:///system
fi
