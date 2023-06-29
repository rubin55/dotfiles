#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which rpmbuild || return

export RPM_BUILD_NCPUS=$(nproc)

