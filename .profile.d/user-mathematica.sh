#!/bin/bash

# Set IFS.
old_IFS=$IFS
IFS=:

# Determine Mathematica home and add to path and manpath.
MATHEMATICA_HOMES=("/opt/Mathematica:/opt/wolfram/mathematica13")
for MATHEMATICA_HOME in $MATHEMATICA_HOMES; do
  if [ -d "$MATHEMATICA_HOME" ]; then
     PATH_NEW="$MATHEMATICA_HOME/Executables"
     MANPATH_NEW="$MATHEMATICA_HOME/SystemFiles/SystemDocumentation/Unix"
     if [ ! -L "$MANPATH_NEW/man1" ]; then
       cd "$MANPATH_NEW"
       ln -s . man1
       cd - > /dev/null 2>&1
     fi
     break
  fi
done

# Reset IFS.
IFS=$old_UFS

# Add path, manpath (prefixed ':' is intentional, see man manpath).
export PATH="$(path.append "$PATH_NEW" "$PATH")"
export MANPATH=":$(path.append "$MANPATH_NEW" "$MANPATH")"
