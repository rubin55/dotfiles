#!/bin/bash

if path.which dotnet; then
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
  export MLDOTNET_CLI_TELEMETRY_OPTOUT=1
fi
