#!/bin/bash

# Check if functions are loaded.
type -p os.platform path.append path.which || return

if [[ "$(os.platform)" == "darwin" ]]; then
  # Prefer Python 3.x if it's installed, else fall back
  # on the ancient system-provided 2.7 version.
  PYTHON_HOME="/Library/Frameworks/Python.framework/Versions/Current"
  if path.which python3 $PATH:$PYTHON_HOME/bin; then
    export PATH=$(path.append "$PYTHON_HOME/bin" "$PATH")
    PYTHON_EXEC=python3
    PYTHON_VERSION="$($PYTHON_EXEC -c 'import sys; print(str(sys.version_info[0])+"."+str(sys.version_info[1]))')"
  else
    PYTHON_EXEC=python2
    PYTHON_VERSION=2.7
  fi

  # Make sure things like pip shut up about deprecation.
  export PYTHONWARNINGS="ignore:DEPRECATION"

  # Add local Python home to path if not in path already.
  export PATH=$(path.append "$HOME/Library/Python/$PYTHON_VERSION/bin" "$PATH")
fi
