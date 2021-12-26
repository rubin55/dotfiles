#!/bin/bash

# What are we running on?
platform=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$(uname -r)" =~ "icrosoft" ]] && platform=windows

# Default manpath candidates.
MANPATH_CANDIDATES="/usr/man:/usr/share/man:/usr/local/man:/usr/local/share/man:/snap/man:$HOME/.ghcup/share/man:$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/man"

# Check if candidates exist, only add those.
OLD_IFS=$IFS ; IFS=:
for MANPATH_ELEMENT in $MANPATH_CANDIDATES; do
    if [ -d "$MANPATH_ELEMENT" ]; then
        MANPATH+="$MANPATH_ELEMENT:"
    fi
done
IFS=$OLD_IFS

# Extra manpath entry for node/nvm, needs a version lookup..
NVM_DEFAULT_ALIAS="$HOME/.nvm/alias/default"
if [ -e "$NVM_DEFAULT_ALIAS" ]; then
    NVM_DEFAULT_VERSION=$(cat $NVM_DEFAULT_ALIAS)
    MANPATH+="$HOME/.nvm/versions/node/$NVM_DEFAULT_VERSION/share/man:"
fi

# Extra manpath elements for programs in /opt.
MANPATH+="$(find /opt -maxdepth 5 -type d -name man | tr '\n' ':')"

export MANPATH
