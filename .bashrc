# ~/.bashrc: executed by bash(1) for non-login shells.

[ -z "$PS1" ] && return

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

# Set platform type.
platform=$(uname -o | tr '[:upper:]' '[:lower:]')

case "$platform" in
    bsd|gnu/linux|linux|unix)
    # Some handy variables (*nix only).
    export _JAVA_AWT_WM_NONREPARENTING=1
    #export SWT_GTK3=0
    export GDK_USE_XFT=1
    export QT_XFT=true
    export QT_QPA_PLATFORMTHEME=qt5ct
    export GIT_SSH=/usr/bin/ssh
    export XDG_CONFIG_HOME="$HOME/.config"
    export GEM_HOME="$HOME/.gem/ruby/2.3.0"
    export GOPATH="$HOME/.go"
    export SAL_USE_VCLPLUGIN=gtk
    export RUST_SRC_PATH="$HOME/.cargo/source/rustc-1.13.0/src"

    # Set up gpg-agent (notice: enable-ssh-support in gpg-agent.conf).
    GPG_TTY="$(tty)"
    export GPG_TTY
    GPG_AGENT_DETECTED="$(ps x | grep gpg-agent | grep -v grep)"
    GPG_AGENT_SRCFILE="$HOME/.session/tmp/session.gpg-agent.out"
    if [ -z "$GPG_AGENT_DETECTED" ]; then
        gpg-agent --daemon > "$GPG_AGENT_SRCFILE"
        source "$GPG_AGENT_SRCFILE"
    else
        source "$GPG_AGENT_SRCFILE"
    fi
    ;;
    cygwin|msys)
    # Set up ssh-pageant bridge (notice: enable-putty-support in gpg-agent.conf).
    eval $(ssh-pageant -r -a "/tmp/.ssh-pageant-$USERNAME")
    ;;
    *)
    echo "Unknown platform \"$platform\", not doing agent setup."
esac

# Custom alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features.
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
