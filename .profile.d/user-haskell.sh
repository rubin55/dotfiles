#!/bin/bash

STACK_EXEC=$(which stack 2> /dev/null)
if [ ! -z "$STACK_EXEC" ]; then
    export STACK_ROOT="$HOME/.stack/root"
fi
