#!/bin/bash

# Prefix ~/.local/bin to path if not in path already
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Determine SCRIPTS_HOME.
SCRIPTS_HOMES="$HOME/Syncthing/Source/Rubin/scripts $HOME/Source/scripts"
for POSSIBLE_SCRIPTS_HOME in $SCRIPTS_HOMES; do
    if [ -d "$POSSIBLE_SCRIPTS_HOME" ]; then
        SCRIPTS_HOME="$POSSIBLE_SCRIPTS_HOME"
        break
    fi
done

# Add scripts directories to path that make sense on unix-likes.
if [ -n "$SCRIPTS_HOME" ]; then
    for DIR in perl power python ruby shell; do
        if [ -d "$SCRIPTS_HOME/$DIR" ] && [[ ":$PATH:" != *":$SCRIPTS_HOME/$DIR:"* ]]; then
            export PATH="${PATH:+"$PATH:"}$SCRIPTS_HOME/$DIR"
        fi
    done
fi

# Add extra script directories to path.
SCRIPTS_EXTRAS="/opt/jetbrains/scripts $HOME/Syncthing/Source/RAAF/session $HOME/Syncthing/Source/ICTU/various/helmster/bin"
for EXTRA in $SCRIPTS_EXTRAS; do
    if [ -d "$EXTRA" ] && [[ ":$PATH:" != *":$EXTRA:"* ]]; then
        export PATH="${PATH:+"$PATH:"}$EXTRA"
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

# Code, Emacs and Vim.
if [[ "$(uname -s)" =~ "arwin" ]]; then
    alias em='em-mac.sh'
    alias vi='vi.sh'
elif [[ "$(uname -r)" =~ "icrosoft" ]]; then
    alias em='em-windows.sh'
    alias vi='vi.sh'
    alias code='code.exe'
elif [[ "$(uname -s)" =~ "inux" ]]; then
    alias emacs='GDK_BACKEND=x11 emacs'
    alias gvim='GDK_BACKEND=x11 gvim'
    alias em='em-linux.sh'
    alias vi='vi.sh'

    # If no code, assume code-oss.
    which code > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        alias code='code-oss'
    fi
fi

# If no gpg, assume gpg2.
which gpg > /dev/null 2>&1
if [[ $? != 0 ]]; then
    alias gpg='gpg2'
fi

# A few other aliases.
alias kc='kubectl'
alias open='opener.sh'
alias dbcluster='dbcluster.sh'
alias helmster='helmster.sh'
alias session='session.sh'
alias tipi='tipi.py'
alias pgctl='pgctl.sh'
alias rmqctl='rmqctl.sh'
alias pgo='pgo-wrapper.sh'
alias spotify='spotify --no-xshm --ignore-gpu-blacklist'

# Set default SciPy image viewer.
export SCIPY_PIL_IMAGE_VIEWER=display

# Set the default editor.
export EDITOR='vi.sh'

# My title function.
function title() {
    [[ -z "$orig" ]] && orig=$PS1
    local title="\[\e]2;$*\a\]"
    PS1=${orig}${title};
}

# I have my preference for PS1.
scm_ps1() {
    typeset git=$(which git 2> /dev/null)
    typeset git_prompt=$(which git-prompt.sh 2> /dev/null)
    typeset svn=$(which svn 2>/dev/null)
    typeset svn_prompt=$(which svn-prompt.sh 2> /dev/null)
    typeset s
    if [[ -n "$git" && -n "$git_prompt" ]]; then
        source "$git_prompt"
        s="$(__git_ps1 ' (%s)')"
    elif [[ -n "$svn" && -n "$svn_prompt" ]]; then
        svn info > /dev/null 2>&1
        if [[ $? = 0 ]] ; then
            source "$svn_prompt"
            s="$(__svn_ps1 ' (%s)')"
        fi
    fi

    echo -n "$s"
}

# Only do color and title setting if we're not on stupid terminals.
stupid="dumb eterm eterm-color vt100"
if [[ ! $stupid =~ $TERM ]]; then
    # Set my own fancy prompt.
    PS1='[\u@\h \[\033[01;94m\]\W\[\033[00;31m\]$(scm_ps1)\[\033[0m\]]\$ '

    # Set terminal title to title-cased hostname.
    title=$(hostname | cut -d '.' -f 1 | tr '[:upper:]' '[:lower:]' | awk '{for(j=1;j<=NF;j++){ $j=toupper(substr($j,1,1)) substr ($j,2) }}1')
    title "$title"

    # Prevent run-by-bash-apps to change title
    PROMPT_COMMAND='echo -en "\033]0;\a"'
else
    # Set my own fancy, colorless prompt.
    PS1='[\u@\h \W$(scm_ps1)]\$ '
fi

# Set my default umask.
currentUser="$(id -un)"
currentGroup="$(id -gn)"
if [[ $currentUser == $currentGroup ]]; then
    umask 0002
else
    umask 0022
fi

# If on Windows, on a specific host, maximize the screen.
hostName="$(hostname | tr [:upper:] [:lower:])"
if [[ "$(uname -r)" =~ "icrosoft" && "$hostName" =~ "surface" ]]; then
    winPids="$(tasklist.exe | grep debian.exe | awk '{print $2}')"
    for winPid in $winPids; do
        window-mode.exe -pid "$winPid" -mode maximized > /dev/null 2>&1
    done
fi

# Invoke some conditional runners.
# See user-syncthing.sh, user-sway.sh, user-scaling.sh.
runSyncthing
runSway
runScaling
