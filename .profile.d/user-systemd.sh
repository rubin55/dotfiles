#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which journalctl,systemctl || return

# Set a shorter aliases
alias jc='journalctl'
alias jcu='journalctl --user'
alias sc='systemctl'
alias scu='systemctl --user'

# Add completion support to bash.
source /usr/share/bash-completion/completions/systemctl
source /usr/share/bash-completion/completions/journalctl
complete -F _systemctl sc
complete -F _systemctl scu
complete -F _journalctl jc
complete -F _journalctl jcu
