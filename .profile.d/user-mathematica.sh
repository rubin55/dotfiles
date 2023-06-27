#!/bin/bash

# Strange manpath for Mathematica.
MANPATH_NEW="/opt/Mathematica/SystemFiles/SystemDocumentation/Unix"
if [ -d "$MANPATH_NEW" ]; then
  if [ ! -L "$MANPATH_NEW/man1" ]; then
    cd "$MANPATH_NEW"
    ln -s . man1
    cd - > /dev/null 2>&1
  fi

  export MANPATH="$(path.append "$MANPATH_NEW" "/usr:share/man:/usr/local/share/man:$MANPATH")"
fi
