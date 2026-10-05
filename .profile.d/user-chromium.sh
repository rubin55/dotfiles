#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return

# Check if chromium is available.
path.which which,chromium || return

# Various preferences.
export CHROME_EXECUTABLE=$(which chromium)
