# ~/.bashrc: executed by bash(1) for non-login shells.

[ -z "$PS1" ] && return

# Custom alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features.
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Source scripts in ~/.profile.d if exists.
if [ -d ~/.profile.d -o -h ~/.profile.d ]; then
    for s in ~/.profile.d/*.sh; do
        source $s
    done
fi
