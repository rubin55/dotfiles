#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.append path.which || return
path.which ln || return

# Set IFS.
old_IFS=$IFS
IFS=:

# Determine Wolfram home and add to path and manpath.
WOLFRAM_HOMES=("/opt/wolfram")
for WOLFRAM_HOME in $WOLFRAM_HOMES; do
  if [[ -d "$WOLFRAM_HOME" ]]; then
     PATH_NEW="$WOLFRAM_HOME/Executables"
     MANPATH_NEW="$WOLFRAM_HOME/SystemFiles/SystemDocumentation/Unix"
     if [[ ! -L "$MANPATH_NEW/man1" ]]; then
       cd "$MANPATH_NEW"
       ln -s . man1
       cd - > /dev/null 2>&1
     fi
     break
  fi
done

# Reset IFS.
IFS=$old_IFS

# Add path, manpath (prefixed ':' is intentional, see man manpath).
export PATH="$(path.append "$PATH_NEW" "$PATH")"
export MANPATH=":$(path.append "$MANPATH_NEW" "$MANPATH")"

# Unset temporary variables.
unset WOLFRAM_HOMES WOLFRAM_HOME PATH_NEW MANPATH_NEW old_IFS
