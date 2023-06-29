#!/bin/bash

# Check if functions are loaded.
type -p path.append path.which || return

PERL_VIRTUALENV_DIR="$HOME/Syncthing/Source/Other/perl-virtualenv"
export PATH=$(path.append "$PERL_VIRTUALENV_DIR" "$PATH")
