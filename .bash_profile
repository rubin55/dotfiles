# ~/.bash_profile: executed by bash(1) for login shells.

[ -z "$PS1" ] && return

# Custom alias definitions.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Custom function definitions.
if [ -f ~/.bash_functions ]; then
  . ~/.bash_functions
fi

# Source scripts in ~/.profile.d if exists.
if [ -d ~/.profile.d -o -h ~/.profile.d ]; then
  for s in ~/.profile.d/*.sh; do
    source $s
  done
fi
