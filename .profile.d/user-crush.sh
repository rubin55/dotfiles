#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which crush || return

# Opt out of crush telemetry.
export CRUSH_DISABLE_METRICS=1

