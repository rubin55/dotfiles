#!/bin/bash

# Check existence of list of known executables. If exists,
# eventually add the parent directory to the path.
known_executables="$HOME/.known-executables"
if [ -e "$known_executables" ]; then
  while read executable; do
    if [ -x "$executable" ]; then
      PATH_NEW+="$(dirname "$executable"):"
    fi
  done < "$known_executables"
fi

# Add detected directories to the PATH.
PATH="$(path.append "$PATH_NEW" "$PATH")"

# Check existence of list of known manpaths. If exists,
# eventually add the directory to the manpath.
known_manpaths="$HOME/.known-manpaths"
if [ -e "$known_manpaths" ]; then
  while read manpath; do
    if [ -d "$manpath" ]; then
      MANPATH_NEW+="$manpath:"
    fi
  done < "$known_manpaths"
fi

# Add detected directories to the MANPATH.
# Note: prefixed ':' is intentional (man manpath).
MANPATH=":$(path.append "$MANPATH_NEW" "$MANPATH")"