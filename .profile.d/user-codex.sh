#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which codex || return

# Add completion support to bash, generated on first use. This loads
# before user-scripts.sh, so codex-util.py is not on PATH yet here.
_codex_util_load() {
  path.which codex-util.py || return
  source <(codex-util.py completion)
  complete -F _codex_util codex-util
  _codex_util
}
complete -F _codex_util_load codex-util.py codex-util
