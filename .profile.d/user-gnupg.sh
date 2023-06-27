#!/bin/bash

# Set up gpg-agent (note: enable-ssh-support in gpg-agent.conf).
if path.which tty,gpg-agent,gpgconf; then
  export GPG_TTY="$(tty)"

  if [ -z "$SSH_CLIENT" ]; then
    GPG_AGENT_DETECTED="$(ps x | grep gpg-agent | grep -v grep)"
    if [ -z "$GPG_AGENT_DETECTED" ]; then
      gpg-agent --daemon > /dev/null
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    else
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    fi
  fi

  # Make sure the current tty can connect to the agent.
  gpg-connect-agent updatestartuptty /bye > /dev/null
fi
