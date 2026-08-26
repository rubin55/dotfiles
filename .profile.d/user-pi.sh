#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return

# Check if claude is available.
path.which pi || return

# Various preferences.
export PI_LENS_DISABLE_LSP_INSTALL=1
export PI_LENS_DISABLE_TOOL_INSTALL=1

