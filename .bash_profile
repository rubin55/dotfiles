# ~/.bash_profile: executed by bash(1) for login shells.

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# I have my preference for PS1.
scm_ps1() {
    typeset s
    svn info > /dev/null 2>&1
    if [[ $? = 0 ]] ; then
        source /usr/local/bin/svn-prompt
        s="$(__svn_ps1 ' (%s)')"
    else
        source /usr/local/bin/git-prompt
        s="$(__git_ps1 ' (%s)')"
    fi

    echo -n "$s"
}
PS1='[\u@\h \[\033[01;94m\]\W\[\033[00;31m\]$(scm_ps1)\[\033[0m\]]\$ '

# Expand PATH with some local things.
export PATH=$PATH:"$HOME/.local/bin":"$HOME/.python/bin":"$HOME/.gem/ruby/2.3.0/bin":"$HOME/.npm/bin":"$HOME/.go/bin":"$HOME/.cargo/bin"

# Set the terminal title.
echo -ne "\033]0;Terminal\007"
