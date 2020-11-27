#!/bin/bash

# If we have gvm, set up go using gvm.
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
[[ -s "$HOME/.gvm/scripts/gvm" ]] && gvm use go1.15 > /dev/null

# A few helpful variables.
[[ $(which go 2>/dev/null | grep -v 'alias ') ]] && GO_EXEC=$(which go 2>/dev/null | grep -v 'alias ' | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//')  && alias go="$GO_EXEC"
[[ $(which go.exe 2>/dev/null | grep -v 'alias ') ]] && GO_EXEC="go.exe" && alias go="$GO_EXEC"
[[ $(which gofmt.exe 2>/dev/null | grep -v 'alias ') ]] && alias gofmt="gofmt.exe"
GO_VERSION=$("$GO_EXEC" version | awk '{print $3}' | sed 's/^go//')
GO_MAJOR=$(echo $GO_VERSION | cut -d. -f 1)
GO_MINOR=$(echo $GO_VERSION | cut -d. -f 2)
GO_PATCH=$(echo $GO_VERSION | cut -d. -f 3)

# Set GOROOT.
#export GOROOT="$(cd $(dirname "$GO_EXEC")/.. && pwd)"

# If GOPATH is unset, set it to something nice.
[[ -z "$GOPATH" ]] && [[ ! -z "$GO_VERSION" ]] && export GOPATH=/home/rubin/.go/$GO_VERSION

# If Go minor version is higher than 11, enable module mode.
if [[ ! -z "$GO_MINOR" && "$GO_MINOR" -ge 11 ]]; then
    export GO111MODULE=on
fi

# Add GOPATH/bin to path if not in path already.
if [[ ":$PATH:" != *":$GOPATH/bin:"* ]]; then
    export PATH="${PATH:+"$PATH:"}$GOPATH/bin"
fi

