# ~/.bash_profile: executed by bash(1) for login shells.

# Add to path.
export PATH=$HOME/.local/bin:$HOME/Syncthing/Source/RAAF/scripts/shell:$HOME/Syncthing/Source/RAAF/scripts/python:$PATH

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

alias error=">&2 echo"

# I have my preference for PS1.
scm_ps1() {
    typeset s
    svn info > /dev/null 2>&1
    if [[ $? = 0 ]] ; then
        source $HOME/Syncthing/Source/RAAF/scripts/shell/svn-prompt.sh
        s="$(__svn_ps1 ' (%s)')"
    else
        source $HOME/Syncthing/Source/RAAF/scripts/shell/git-prompt.sh
        s="$(__git_ps1 ' (%s)')"
    fi

    echo -n "$s"
}

PS1='[\u@\h \[\033[01;94m\]\W\[\033[00;31m\]$(scm_ps1)\[\033[0m\]]\$ '

# Set the terminal title.
echo -ne "\033]0;Terminal\007"

[ -s "/home/rubin/.jabba/jabba.sh" ] && source "/home/rubin/.jabba/jabba.sh"
