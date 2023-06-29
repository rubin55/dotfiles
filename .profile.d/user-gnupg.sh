#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which gpg-agent,gpg-connect-agent,gpgconf,grep,ps,tty || return

# Set up gpg-agent (note: enable-ssh-support in gpg-agent.conf).
export GPG_TTY="$(tty)"

if [[ -z "$SSH_CLIENT" ]]; then
  GPG_AGENT_DETECTED="$(ps x | grep gpg-agent | grep -v grep)"
  if [[ -z "$GPG_AGENT_DETECTED" ]]; then
    gpg-agent --daemon > /dev/null
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  else
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  fi
fi

# Make sure the current tty can connect to the agent.
gpg-connect-agent updatestartuptty /bye > /dev/null

# Unset temporary variables.
unset GPG_AGENT_DETECTED
