#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p log.info path.which || return
path.which cat,cut,docker,sed || return

# Check if we have a marsdev environment.
MARSDEV_PATH="/opt/marsdev/m68k-elf/bin:/opt/marsdev/sh-elf/bin"
if path.which m68k-elf-gcc,sh-elf-gcc $MARSDEV_PATH; then
  log.info "Marsdev compilers found, adding query-driver argument to CLANGD_FLAGS"
  # See: https://clangd.llvm.org/guides/system-headers#query-driver
  export CLANGD_FLAGS='--query-driver="/opt/marsdev/*-elf/bin/*"'
fi
