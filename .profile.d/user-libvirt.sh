#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p os.platform path.which || return
path.which pgrep,libvirtd || return

# Set LIBVIRT_DEFAULT_URI when libvirtd is running.
if [[ "$(os.platform)" == "linux" && "$(pgrep libvirtd)" =~ ^[0-9]+$ ]]; then
  export LIBVIRT_DEFAULT_URI=qemu:///system
fi
