#!/bin/bash

# Note: on macOS 10.14, do: sudo xcode-select --switch /Library/Developer/CommandLineTools
# See: https://stackoverflow.com/questions/20559255/error-while-installing-json-gem-mkmf-rb-cant-find-header-files-for-ruby

# What are we running on?
platform=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$(uname -r)" =~ "icrosoft" ]] && platform=windows

[[ "$(which ruby 2> /dev/null)" ]] && RUBY_EXEC=$(which ruby 2> /dev/null) && alias ruby="$RUBY_EXEC"
[[ "$(which ruby.exe 2> /dev/null)" ]] && RUBY_EXEC=ruby.exe && alias ruby="$RUBY_EXEC"
[[ "$(which gem.cmd 2> /dev/null)" ]] && alias gem="cmd.exe /c gem.cmd"
if [ ! -z "$RUBY_EXEC" ]; then
    RUBY_VERSION=$("$RUBY_EXEC" --version | awk '{print $2}' | sed 's/p.*$//')
    # Note: use Gem.user_dir for setting GEM_HOME, avoid weirdness.
    export GEM_HOME=$("$RUBY_EXEC" -r rubygems -e 'puts Gem.user_dir')

    # Add GEM_HOME/bin to path if not in path already.
    if [[ ":$PATH:" != *":$GEM_HOME/bin:"* ]]; then
        export PATH="${PATH:+"$PATH:"}$GEM_HOME/bin"
    fi

    if [ "$platform" == "linux" ]; then
        export GEM_PATH=/usr/share/gems:$GEM_HOME
    fi

    if [ "$platform" == "darwin" ]; then
        export GEM_PATH=/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/lib/ruby/gems/2.3.0:/Library/Ruby/Gems/2.3.0
    fi
fi
