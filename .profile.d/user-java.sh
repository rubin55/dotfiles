#!/bin/bash

[[ -x "/usr/libexec/java_home" ]] && export JAVA_HOME="$(/usr/libexec/java_home -v 11)"
[[ -s "$HOME/.jabba/jabba.sh" ]] && source "$HOME/.jabba/jabba.sh"

#export _JAVA_AWT_WM_NONREPARENTING=1
export SWT_GTK3=1
