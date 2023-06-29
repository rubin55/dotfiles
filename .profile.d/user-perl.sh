#!/bin/bash

# Check if functions are loaded.
type -p path.append path.which || return

# Add perl-virtualenv git repository to path.
export PATH=$(path.append "$HOME/Syncthing/Source/Other/perl-virtualenv" "$PATH")
