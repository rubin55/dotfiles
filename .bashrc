# ~/.bashrc: sourced by interactive non-login shells, ~/.bash_profile,
# and bash-wrapper.sh. Initializes the shell environment.

# Set default log level.
BASH_LOG_LEVEL=INFO

# Custom alias definitions.
if [ -f "$HOME/.bash_aliases" ]; then
  . "$HOME/.bash_aliases"
fi

# Custom function definitions.
if [ -f "$HOME/.bash_functions" ]; then
  . "$HOME/.bash_functions"
fi

# Check if a few crucial functions are loaded.
type -p log.debug os.platform path.which path.append || return

# Source scripts in ~/.profile.d if exists.
if [ "$BASH_PROFILE_INITIALIZED" != "true" ]; then
  if [ -d "$HOME/.profile.d" ] || [ -h "$HOME/.profile.d" ]; then
    for s in ~/.profile.d/*.sh; do
      log.debug "Loading $s"
      # shellcheck source=/dev/null
      source "$s"
    done
  fi

  # Indicate that this is an initialized environment.
  # Used by bash-wrapper.sh to conditionally init env.
  export BASH_PROFILE_INITIALIZED=true
fi

