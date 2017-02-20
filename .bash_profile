# ~/.bash_profile: executed by bash(1) for login shells.

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

alias error=">&2 echo"

# Take out pound sign from color hex.
get_color() {
    getcolor $1 | sed 's|^\#||g'
}

if [ "$TERM" = "linux" ]; then
    echo -en "\e]P$(get_color color0)" #black
    echo -en "\e]P$(get_color color8)" #darkgrey
    echo -en "\e]P$(get_color color1)" #darkred
    echo -en "\e]P$(get_color color9)" #red
    echo -en "\e]P$(get_color color2)" #darkgreen
    echo -en "\e]P$(get_color color10)" #green
    echo -en "\e]P$(get_color color3)" #brown
    echo -en "\e]P$(get_color color11)" #yellow
    echo -en "\e]P$(get_color color4)" #darkblue
    echo -en "\e]P$(get_color color12)" #blue
    echo -en "\e]P$(get_color color5)" #darkmagenta
    echo -en "\e]P$(get_color color13)" #magenta
    echo -en "\e]P$(get_color color6)" #darkcyan
    echo -en "\e]P$(get_color color14)" #cyan
    echo -en "\e]P$(get_color color7)" #lightgrey
    echo -en "\e]P$(get_color color15)" #white
    clear #for background artifacting
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
export PATH=$PATH:"$HOME/.local/bin"

# Set the terminal title.
echo -ne "\033]0;Terminal\007"
