#!/bin/bash

which dotnet > /dev/null 2>&1
if [ $? == 0 ]; then
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export MLDOTNET_CLI_TELEMETRY_OPTOUT=1
fi

alias dotnet > /dev/null 2>&1
if [ $? == 0 ]; then
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export MLDOTNET_CLI_TELEMETRY_OPTOUT=1
fi

