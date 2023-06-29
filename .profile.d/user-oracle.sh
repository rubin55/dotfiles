#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which sqlplus || return

export ORACLE_PATH="$HOME/.oracle"
export TNS_ADMIN="$HOME/.oracle"

if path.which rlwrap; then
  alias rlsqlplus='rlwrap sqlplus'
fi
