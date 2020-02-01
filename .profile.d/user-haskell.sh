#!/bin/bash

[[ $(which stack 2>/dev/null) ]] && STACK_EXEC=$(which stack 2>/dev/null) && alias stack="$STACK_EXEC"
[[ $(which stack.bat 2>/dev/null) ]] && STACK_EXEC=$(which stack.bat 2>/dev/null) && alias stack="cmd.exe /c stack.bat"

if [[ ! "$STACK_EXEC" =~ "bat" ]]; then
    export STACK_ROOT="$HOME/.stack/root"
fi
