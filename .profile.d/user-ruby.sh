#!/bin/bash

# Disable this configurator due to GEM_HOME setting leading to unforeseen issues
# when packaging on Arch Linux (overrides gem install location system-wide).
return

# Check if functions are loaded and if required executables are available.
type -p os.platform path.append path.which || return
path.which lsb_release || return

# Note: on macOS 10.14, do: sudo xcode-select --switch /Library/Developer/CommandLineTools
# See: https://stackoverflow.com/questions/20559255/error-while-installing-json-gem-mkmf-rb-cant-find-header-files-for-ruby

# Use regular plain old ruby and gem if we have it.
[[ "$(which ruby 2> /dev/null)" && -z "$RUBY_EXEC" ]] && RUBY_EXEC=$(which ruby 2> /dev/null) && alias ruby="$RUBY_EXEC"
[[ "$(which gem 2> /dev/null)" && -z "$GEM_EXEC" ]] && GEM_EXEC=$(which gem 2> /dev/null) && alias gem="$GEM_EXEC"

# Else, if we have jruby, use that and set aliases accordingly.
[[ "$(which jruby 2> /dev/null)" && -z "$RUBY_EXEC" ]] && RUBY_EXEC=$(which jruby 2> /dev/null) && alias ruby="$RUBY_EXEC"
[[ "$(which jgem 2> /dev/null)" && -z "$GEM_EXEC" ]] && GEM_EXEC=$(which jgem 2> /dev/null) && alias gem="$GEM_EXEC"

if [[ -n "$RUBY_EXEC" ]]; then

  # If we're using jruby, enable dev mode by default.
  if [[ "$RUBY_EXEC" =~ 'jruby' ]]; then
    export JRUBY_OPTS="--dev"
  fi

  # Get major and minor version number of ruby.
  RUBY_VERSION=$("$RUBY_EXEC" -e 'major, minor, patch = RUBY_VERSION.split("."); puts "%s.%s" % [major, minor]' 2> /dev/null)

  # If we actually received a version string, continue.
  if [[ -n "$RUBY_VERSION" ]]; then

    # Note: use Gem.user_dir for setting GEM_HOME, avoid weirdness.
    export GEM_HOME=$("$RUBY_EXEC" -r rubygems -e 'puts Gem.user_dir')

    # Add GEM_HOME/bin to path if not in path already.
    export PATH=$(path.append "$GEM_HOME/bin" "$PATH")

    if [[ "$(os.platform)" == "linux" ]]; then
      distro=$(lsb_release -i | cut -d: -f2 | sed 's/[[:blank:]]//g' | tr '[:upper:]' '[:lower:]')

      case "$distro" in
        gentoo*)
        export GEM_PATH=/usr/lib64/ruby/gems/$RUBY_VERSION.0:$GEM_HOME
        ;;
        redhat*)
        export GEM_PATH=/usr/share/gems:$GEM_HOME
        ;;
        arch*|pop*|ubuntu*|voidlinux*)
        ;;
        *)
        echo "Warning: Don't know distro: $distro; don't know how to set GEM_PATH."
        ;;
      esac
    fi

    if [[ "$(os.platform)" == "darwin"  && "$RUBY_VERSION" == "2.3" ]]; then
      export GEM_PATH=/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/lib/ruby/gems/2.3.0:/Library/Ruby/Gems/2.3.0
    fi
  fi
fi

# Unset temporary variables.
unset GEM_EXEC RUBY_EXEC RUBY_VERSION distro
