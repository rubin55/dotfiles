#!/bin/bash

# Add ~/.local/bin to path if not in path already
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="${PATH:+"$PATH:"}$HOME/.local/bin"
fi

# Add scripts directories to path that make sense on unix-likes.
SCRIPTS_HOME="$HOME/Syncthing/Source/RAAF/scripts"
for DIR in perl python ruby shell; do
    if [ -d "$SCRIPTS_HOME/$DIR" ] && [[ ":$PATH:" != *":$SCRIPTS_HOME/$DIR:"* ]]; then
        export PATH="${PATH:+"$PATH:"}$SCRIPTS_HOME/$DIR"
    fi
done

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1).
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable color support of ls and also add handy aliases.
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# De-facto standard aliases.
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Emacs and Vim.
if [ "$(uname -s)" == "Darwin" ]; then
    alias em='em-mac.sh'
    alias vim='vi.sh'
    alias vi='vi.sh'
fi
if [ "$(uname -s)" == "Linux" ]; then
    alias em='em-linux.sh'
    alias vim='vi.sh'
    alias vi='vi.sh'
fi
if [[ "$(uname -r)" =~ "icrosoft" ]]; then
    alias em='em-windows.sh'
    alias vim='vi.sh'
    alias vi='vi.sh'
fi

# A few other aliases.
alias open='opener.sh'
alias session='$HOME/Syncthing/Source/RAAF/session/session.sh'
alias tipi='tipi.sh'
alias pgctl='pgctl.sh'
alias rmqctl='rmqctl.sh'
alias pgo='pgo-wrapper.sh'


# Set the default editor.
export EDITOR='vi.sh'

# I have my preference for PS1.
scm_ps1() {
    typeset git=$(which git 2> /dev/null)
    typeset svn=$(which svn 2>/dev/null)
    typeset s
    if [ ! -z "$git" ]; then
        source $(which git-prompt.sh 2>/dev/null)
        s="$(__git_ps1 ' (%s)')"
    elif [ ! -z "$svn" ]; then
        svn info > /dev/null 2>&1
        if [[ $? = 0 ]] ; then
            source $(which svn-prompt.sh 2>/dev/null)
            s="$(__svn_ps1 ' (%s)')"
        fi
    fi

    echo -n "$s"
}

PS1='[\u@\h \[\033[01;94m\]\W\[\033[00;31m\]$(scm_ps1)\[\033[0m\]]\$ '

# Set the terminal title.
echo -ne "\033]0;Terminal\007"
