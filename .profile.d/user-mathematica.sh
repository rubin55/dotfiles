#!/bin/bash

# Set IFS.
old_IFS=$IFS
IFS=:

# Strange manpaths for Mathematica.
MATHEMATICA_HOMES=("/opt/Mathematica:/opt/wolfram/mathematica13")
for MATHEMATICA_HOME in $MATHEMATICA_HOMES; do
  if [ -d "$MATHEMATICA_HOME" ]; then
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

# Add MANPATH.
export MANPATH=":$(path.append "$MANPATH_NEW" "$MANPATH")"
