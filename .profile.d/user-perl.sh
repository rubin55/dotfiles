#!/bin/bash

PERL_VIRTUALENV_DIR=$HOME/Syncthing/Source/Other/perl-virtualenv
if [[ -x "$PERL_VIRTUALENV_DIR/virtualenv.pl" ]]; then
    if [[ ":$PATH:" != *":$PERL_VIRTUALENV_DIR:"* ]]; then
        export PATH="${PATH:+"$PATH:"}$PERL_VIRTUALENV_DIR"
    fi
fi

