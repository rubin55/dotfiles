#!/bin/bash

# Set up gpg-agent (notice: enable-ssh-support in gpg-agent.conf).
TTY="$(which tty 2>/dev/null)"
GPG_AGENT="$(which gpg-agent 2>/dev/null)"
GPG_CONF="$(which gpgconf 2>/dev/null)"

if [ -x "$TTY" -a -x "$GPG_AGENT" -a -x "$GPG_CONF" ]; then
    GPG_TTY="$(tty)"
    export GPG_TTY

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
