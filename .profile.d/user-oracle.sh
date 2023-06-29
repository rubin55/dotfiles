#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which sqlplus || return

export ORACLE_PATH="$HOME/.oracle"
export TNS_ADMIN="$HOME/.oracle"

RLWRAP_EXEC=$(which rlwrap 2>/dev/null)
if [[ -n "$RLWRAP_EXEC" ]]; then
  alias rlsqlplus='rlwrap sqlplus'
fi

