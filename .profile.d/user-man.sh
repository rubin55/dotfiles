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

# Extra strange manpath for Mathematica.
MATHEMATICA_MANPAGES="/opt/wolfram/mathematica13/SystemFiles/SystemDocumentation/Unix"
if [ -d "$MATHEMATICA_MANPAGES" ]; then
    if [ ! -L "$MATHEMATICA_MANPAGES/man1" ]; then
        echo fo
        cd "$MATHEMATICA_MANPAGES"
        ln -s . man1
        cd - > /dev/null 2>&1
    fi
    MANPATH_NEW+=":$MATHEMATICA_MANPAGES"
fi

# Make sure we don't have empty entries.
export MANPATH=$(echo "$MANPATH_NEW" | sed "s|::|:|g")

# Override man to make LESS use colors instead of actual bold/underline/standout.
function man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[45;93m' \
    LESS_TERMCAP_se=$'\e[0m' \
    command man "$@"
}
