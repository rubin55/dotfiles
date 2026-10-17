#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return

# Check if claude is available.
path.which claude || return

# Various preferences.
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=1
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1

# Add completion support to bash, generated on first use. This loads
# before user-scripts.sh, so claude-util.py is not on PATH yet here.
_claude_util_load() {
  path.which claude-util.py || return
  source <(claude-util.py completion)
  complete -F _claude_util claude-util
  _claude_util
}
complete -F _claude_util_load claude-util.py claude-util
