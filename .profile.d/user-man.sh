#!/bin/bash

# Default manpath candidates.
MANPATH_CANDIDATES="$MANPATH:/usr/man:/usr/share/man:/usr/local/man:/usr/local/share/man:/snap/man:$HOME/.ghcup/share/man:$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/man"

# Check if candidates exist, only add those.
OLD_IFS=$IFS ; IFS=:
for MANPATH_ELEMENT in $MANPATH_CANDIDATES; do
    if [[ -d "$MANPATH_ELEMENT" && ":$MANPATH_NEW:" != *":$MANPATH_ELEMENT:"* ]]; then
        MANPATH_NEW="${MANPATH_NEW:+"$MANPATH_NEW:"}$MANPATH_ELEMENT"
    fi
done
IFS=$OLD_IFS

# Extra manpath elements for programs in /opt.
MANPATH_NEW+=":$(find /opt -maxdepth 5 -type d -name man 2>/dev/null| tr '\n' ':')"

# Make sure we don't have empty entries.
export MANPATH=$(echo "$MANPATH_NEW" | sed "s|::|:|g")

