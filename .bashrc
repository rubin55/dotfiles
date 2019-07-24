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
platform=$(uname -s | tr '[:upper:]' '[:lower:]')

case "$platform" in
    bsd|darwin|gnu/linux|linux|unix)
    # Some handy variables (*nix only).
    #export SWT_GTK3=0
    export _JAVA_AWT_WM_NONREPARENTING=1
    export QT_AUTO_SCREEN_SCALE_FACTOR=0
    export QT_QPA_PLATFORMTHEME="qt5ct"
    #export XDG_CURRENT_DESKTOP=Unity
    export GDK_SCALE=1
    export GDK_USE_XFT=1
    export QT_XFT=true
    export XDG_CONFIG_HOME="$HOME/.config"
    export SAL_USE_VCLPLUGIN=gtk
    #export DROPBOX_USE_LIBAPPINDICATOR=1
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export GEM_HOME="$HOME/.gem/ruby/2.5"
    export GIT_SSH="/usr/bin/ssh"
    #export JAVA_HOME="$(/usr/libexec/java_home -v 1.8.0)"
    export STACK_ROOT="$HOME/.stack/root"
    #export PGDATA=/Library/PostgreSQL/data
    export ORACLE_PATH="$HOME/.oracle"
    export TNS_ADMIN="$HOME/.oracle"

    # Set up gpg-agent (notice: enable-ssh-support in gpg-agent.conf).
    GPG_TTY="$(tty)"
    export GPG_TTY
    GPG_AGENT_DETECTED="$(ps x | grep gpg-agent | grep -v grep)"
    if [ -z "$GPG_AGENT_DETECTED" ]; then
        gpg-agent --daemon
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    else
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    fi

    # Set up proxy when connected to a certain wireless network.
    #SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')
    #if [ "$SSID" == "Corporate" ]; then
    #    echo "Notice: connected to Corporate network, enabling proxy settings.."
    #    proxy-mac.sh on > ~/.proxy.env
    #else
    #    proxy-mac.sh off > ~/.proxy.env
    #fi
    #source ~/.proxy.env

    # Set up proxy when a certain SSH command is detected as running.
    CHECK=$(ps ax | grep 'ssh -4 -L 10.10.10.1:49151:194.109.6.13:8080 -D 10.10.10.1:1080 -p 443 rubin@shell.xs4all.nl' | grep -v grep)
    if [ ! -z "$CHECK" ]; then
        echo "Notice: SSH with proxy tunneling detected, enabling proxy settings.."
        http_proxy=http://10.10.10.1:49151
        https_proxy=$http_proxy
        HTTP_PROXY=$http_proxy
        HTTPS_PROXY=$http_proxy
        export http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
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

# Java environment setup using jabba.
[[ -s "$HOME/.jabba/jabba.sh" ]] && source "$HOME/.jabba/jabba.sh"

# Node environment setup using nvm.
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh" 2> /dev/null
nvm use v10.16.0 > /dev/null

# Rust environment setting (if using rustup).
[[ -s "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Go environment setup using gvm.
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
gvm use go1.12 > /dev/null

