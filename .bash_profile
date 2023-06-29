# ~/.bash_profile: executed by bash(1) for login shells.

[ -z "$PS1" ] && return

# Set default log level.
BASH_LOG_LEVEL=INFO

# Custom alias definitions.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Custom function definitions.
if [ -f ~/.bash_functions ]; then
  . ~/.bash_functions
fi

# Check if a few crucial functions are loaded.
type -p log.debug os.platform path.which path.append || return

# Source scripts in ~/.profile.d if exists.
if [ -d ~/.profile.d -o -h ~/.profile.d ]; then
  for s in ~/.profile.d/*.sh; do
    log.debug "Loading $s"
    source $s
  done
fi
