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
PATH=$(path.append "$PATH_NEW" "$PATH")
