#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p os.platform path.which title.set title.case host.short-name log.info || return
path.which awk,cut,grep,hostname,tr || return

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1).
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable dircolors if available.
if path.which dircolors; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Set default editor.
path.which gvim.sh && export EDITOR='gvim.sh'

# Set up less to use lessfilter (pygments).
export PAGER='less'
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'

# Tell less to colorize certain things a certain way (works for man, etc).
export GROFF_NO_SGR=1
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;34m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;90m'
export LESS_TERMCAP_se=$'\e[0m'

# Make xz use multiple threads by default.
export XZ_DEFAULTS="-T 0"

# If we have git and git-prompt.sh somewhere, source git-prompt.sh.
if path.which git,git-prompt.sh; then
  source "$(which git-prompt.sh)"
else
  # Set up dummy __git_ps1 function since git-prompt.sh was not found.
  __git_ps1() { true; }
fi

# Only do color if we're not on stupid terminals.
stupid="dumb eterm eterm-color vt100"
if [[ ! $stupid =~ $TERM ]]; then
    # Set my own fancy prompt.
    PS1='[\u@\h \[\033[01;94m\]\W\[\033[00;31m\]$(__git_ps1 " (%s)")\[\033[0m\]]\$ '
else
    # Set my own fancy, colorless prompt.
    PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
fi

# Set terminal title to title-cased hostname.
title.set $(title.case $(host.short-name))

# Prevent run-by-bash-apps to change title
PROMPT_COMMAND='echo -en "\033]0;\a"'

# Set default umask.
current_user="$(id -un)"
current_group="$(id -gn)"
if [[ $current_user == $current_group ]]; then
    umask 0002
else
    umask 0022
fi

# If on Windows, on a specific host, maximize the screen.
if [[ "$(os.platform)" == "windows" && "$(hostname | tr [:upper:] [:lower:])" =~ "surface" ]]; then
    winPids="$(tasklist.exe | grep debian.exe | awk '{print $2}')"
    for winPid in $winPids; do
        window-mode.exe -pid "$winPid" -mode maximized > /dev/null 2>&1
    done
fi

# Unset temporary variables.
unset current_group current_user stupid winPids winPid
