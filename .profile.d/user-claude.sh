#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return

# Check if claude is available.
path.which claude || return

# Various preferences.
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1

