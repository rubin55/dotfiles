#!/bin/bash

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
export EDITOR='gvim.sh'

# Set up less to use lessfilter (pygments).
export PAGER='less'
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'

# Only do color and title setting if we're not on stupid terminals.
stupid="dumb eterm eterm-color vt100"
if [[ ! $stupid =~ $TERM ]]; then
    # Set my own fancy prompt.
    PS1='[\u@\h \[\033[01;94m\]\W\[\033[00;31m\]$(prompt)\[\033[0m\]]\$ '

    # Set terminal title to title-cased hostname.
    title=$(hostname | cut -d '.' -f 1 | tr '[:upper:]' '[:lower:]' | awk '{for(j=1;j<=NF;j++){ $j=toupper(substr($j,1,1)) substr ($j,2) }}1')
    title "$title"

    # Prevent run-by-bash-apps to change title
    PROMPT_COMMAND='echo -en "\033]0;\a"'
else
    # Set my own fancy, colorless prompt.
    PS1='[\u@\h \W$(prompt)]\$ '
fi

# Set my default umask.
current_user="$(id -un)"
current_group="$(id -gn)"
if [[ $current_user == $current_group ]]; then
    umask 0002
else
    umask 0022
fi

# If on Windows, on a specific host, maximize the screen.
hostname="$(hostname | tr [:upper:] [:lower:])"
if [[ "$(os.platform)" == "windows" && "$hostname" =~ "surface" ]]; then
    winPids="$(tasklist.exe | grep debian.exe | awk '{print $2}')"
    for winPid in $winPids; do
        window-mode.exe -pid "$winPid" -mode maximized > /dev/null 2>&1
    done
fi
