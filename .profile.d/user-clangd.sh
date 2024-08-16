#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p log.debug path.which || return
path.which clangd || return

# See: https://clangd.llvm.org/guides/system-headers#query-driver
if [ -z "$CLANGD_FLAGS" ]; then
  clangd_globs="/usr/**,/opt/**"
  log.debug "Setting default clangd --query-driver globs to: $clangd_globs"
  export CLANGD_FLAGS="--query-driver='$clangd_globs'"
else
  log.debug "Not setting clangd --query-driver globs, because CLANGD_FLAGS is already set.."
fi
