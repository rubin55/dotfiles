#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p log.info net.port-open path.which || return
path.which cat,cut,docker,sed || return

# Check if we have the buildx plugin, use buildx if yes.
DOCKER_CLI_PLUGINS_PATH="$HOME/.docker/cli-plugins:/usr/local/lib/docker/cli-plugins:/usr/local/libexec/docker/cli-plugins:/usr/lib/docker/cli-plugins:/usr/libexec/docker/cli-plugins"
if path.which docker-buildx $DOCKER_CLI_PLUGINS_PATH; then
  log.info "Buildx plugin found, setting DOCKER_BUILDKIT=1"
  export DOCKER_BUILDKIT=1
fi

# Check for a docker host string on this host.
if [ -e "$HOME/.docker/host.string" ]; then
  DOCKER_HOST="$(cat "$HOME/.docker/host.string")"
fi

# Check if minikube is available and if it's running first.
if path.which minikube && minikube status | grep -qw 'apiserver: Running'; then
  eval $(minikube docker-env) && \
  log.info "Minikube is running, setting DOCKER_HOST=$DOCKER_HOST"
elif [ -n "$DOCKER_HOST" ]; then
  DOCKER_TYPE=$(echo "$DOCKER_HOST" | cut -d: -f1)
  DOCKER_ADDR=$(echo "$DOCKER_HOST" | cut -d: -f2 | sed 's|^.*//||g; s|^.*@||g')
  DOCKER_PORT=$(echo "$DOCKER_HOST" | cut -d: -f3)

  # If DOCKER_PORT is empty, get port number from DOCKER_TYPE.
  declare -A DOCKER_NAMED_PORTS=([ssh]=22 [tcp]=2375 [tcps]=2376)
  if [ -z "$DOCKER_PORT" ]; then
    DOCKER_PORT=${DOCKER_NAMED_PORTS[$DOCKER_TYPE]}
  fi

  # Check if port is open and set DOCKER_HOST.
  if net.port-open $DOCKER_ADDR $DOCKER_PORT; then
    export DOCKER_HOST
    log.info "Remote host running, setting DOCKER_HOST=$DOCKER_HOST"

    # Additionally set DOCKER_TLS_VERIFY and DOCKER_CERT_PATH if this is an ecrypted setup.
    if [[ "$DOCKER_TYPE" == "tcp" || "$DOCKER_TYPE" == "tcps" && "$DOCKER_PORT" == "2376" ]]; then
      export DOCKER_TLS_VERIFY="1"
      export DOCKER_CERT_PATH="$HOME/.docker/certs"
    fi
  fi
fi
