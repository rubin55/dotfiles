#!/bin/bash

# Note: on macOS 10.14, do: sudo xcode-select --switch /Library/Developer/CommandLineTools
# See: https://stackoverflow.com/questions/20559255/error-while-installing-json-gem-mkmf-rb-cant-find-header-files-for-ruby

RUBY_EXEC=$(which ruby 2> /dev/null)
if [ ! -z "$RUBY_EXEC" ]; then
    RUBY_VERSION=$(ruby --version | awk '{print $2}' | sed 's/p.*$//')
    # Note: use Gem.user_dir for setting GEM_HOME, avoid weirdness.
    export GEM_HOME=$(ruby -r rubygems -e 'puts Gem.user_dir')

    # Add GEM_HOME/bin to path if not in path already.
    if [[ ":$PATH:" != *":$GEM_HOME/bin:"* ]]; then
        export PATH="${PATH:+"$PATH:"}$GEM_HOME/bin"
    fi

    if [ "$(uname -s)" == "Linux" ]; then
        export GEM_PATH=/usr/share/gems:$GEM_HOME
    fi

    if [ "$(uname -s)" == "Darwin" ]; then
        export GEM_PATH=/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/lib/ruby/gems/2.3.0:/Library/Ruby/Gems/2.3.0
    fi
fi
