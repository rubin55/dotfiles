#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p os.platform path.which || return
path.which pgrep,libvirtd || return

# Set LIBVIRT_DEFAULT_URI when libvirtd is running.
export LIBVIRT_DEFAULT_URI=qemu:///system
