#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which dotnet || return

# Opt out of dotnet telemetry.
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export MLDOTNET_CLI_TELEMETRY_OPTOUT=1

