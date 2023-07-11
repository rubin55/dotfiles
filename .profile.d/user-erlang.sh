#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.append || return

# Arch Linux has a strange manpath location for Erlang.
erlang_manpath="/usr/lib/erlang/man"
if [[ -d "$erlang_manpath" ]]; then
  MANPATH_NEW+="$erlang_manpath:"
fi

# Add manpath (prefixed ':' is intentional, see man manpath).
export MANPATH=":$(path.append "$MANPATH_NEW" "$MANPATH")"

# Unset temporary variables.
unset MANPATH_NEW erlang_manpath
