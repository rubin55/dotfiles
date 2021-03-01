#!/bin/bash
#
# What are we running on?
platform=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$(uname -r)" =~ "icrosoft" ]] && platform=windows

if [[ "$platform" == "linux" ]]; then
    # Default manpath.
    MANPATH="/usr/man:/usr/share/man:/usr/local/man:/usr/local/share/man:/snap/man"

    # Extra manpath.
    EXTRA_MANPATH="/opt/audacious/audacious3/share/man:/opt/docker/docker1903/share/man:/opt/imagemagick/im7/share/man:/opt/java/default/man:/opt/leanux/leanux1/man:/opt/rabbitmq/rmq38/share/man:/opt/scala/scala2/man"

    export MANPATH="$MANPATH:$EXTRA_MANPATH"
fi
