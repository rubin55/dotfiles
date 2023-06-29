#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.append || return
path.which dirname || return

# Check existence of list of known executables. If exists,
# eventually add the parent directory to the path.
known_executables="$HOME/.known-executables"
if [[ -e "$known_executables" ]]; then
  while read executable; do
    if [[ -x "$executable" ]]; then
      PATH_NEW+="$(dirname "$executable"):"
    fi
  done < "$known_executables"
fi

# Add detected directories to the PATH.
export PATH="$(path.append "$PATH_NEW" "$PATH")"

# Check existence of list of known manpaths. If exists,
# eventually add the directory to the manpath.
known_manpaths="$HOME/.known-manpaths"
if [[ -e "$known_manpaths" ]]; then
  while read manpath; do
    if [[ -d "$manpath" ]]; then
      MANPATH_NEW+="$manpath:"
    fi
  done < "$known_manpaths"
fi

# Add manpath (prefixed ':' is intentional, see man manpath).
export MANPATH=":$(path.append "$MANPATH_NEW" "$MANPATH")"

# Unset temporary variables.
unset MANPATH_NEW known_manpaths PATH_NEW known_executables
