#!/bin/bash

SQLPLUS_EXEC=$(which sqlplus 2>/dev/null)
if [ ! -z "$SQLPLUS_EXEC" ]; then
    export ORACLE_PATH="$HOME/.oracle"
    export TNS_ADMIN="$HOME/.oracle"

    RLWRAP_EXEC=$(which rlwrap 2>/dev/null)
    if [ ! -z "$RLWRAP_EXEC" ]; then
        alias rlsqlplus='rlwrap sqlplus'
    fi
fi
