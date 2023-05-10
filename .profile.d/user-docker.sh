#!/bin/bash

# Check if docker is on the path first.
which docker > /dev/null 2>&1
[ $? -eq 0 ] || return

# Check if we have the buildx plugin, use buildx if yes.
OLD_PATH="$PATH"
PATH="/bin:/usr/bin:/usr/local/bin:$HOME/.docker/cli-plugins:/usr/local/lib/docker/cli-plugins:/usr/local/libexec/docker/cli-plugins:/usr/lib/docker/cli-plugins:/usr/libexec/docker/cli-plugins"
which docker-buildx > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Notice: Docker buildx plugin found, setting DOCKER_BUILDX=1"
    export DOCKER_BUILDX=1
fi
PATH="$OLD_PATH"

# Check for a docker host string on this host.
if [ -e "$HOME/.docker/host.string" ]; then
    DOCKER_HOST="$(cat "$HOME/.docker/host.string")"
fi

# Check if minikube is available and if it's running first.
which minikube > /dev/null 2>&1
[ $? == 0 ] &&  minikube status | grep -qw 'apiserver: Running'
if [ $? == 0 ]; then
    eval $(minikube docker-env) && \
    echo "Notice: Minikube is running, setting up DOCKER_HOST=$DOCKER_HOST.."
elif [ ! -z "$DOCKER_HOST" ]; then
    DOCKER_TYPE=$(echo "$DOCKER_HOST" | cut -d: -f1)
    DOCKER_ADDR=$(echo "$DOCKER_HOST" | cut -d: -f2 | sed 's|^.*//||g; s|^.*@||g')
    DOCKER_PORT=$(echo "$DOCKER_HOST" | cut -d: -f3)

    if [ "$DOCKER_TYPE" == "ssh" ]; then
        ping -c 1 -W 1 $DOCKER_ADDR > /dev/null 2>&1 && \
        export DOCKER_HOST && \
        echo "Notice: Docker remote host running, setting DOCKER_HOST=$DOCKER_HOST.."
    elif [ "$DOCKER_PORT" == 2376 ]; then
        DOCKER_TLS_VERIFY="1"
        DOCKER_CERT_PATH="$HOME/.docker/certs"

        ping -c 1 -W 1 $DOCKER_ADDR > /dev/null 2>&1 && \
        export DOCKER_HOST DOCKER_TLS_VERIFY DOCKER_CERT_PATH && \
        echo "Notice: Docker remote host running, setting DOCKER_HOST=$DOCKER_HOST.."
    else
        ping -c 1 -W 1 $DOCKER_ADDR > /dev/null 2>&1 && \
        unset DOCKER_TLS_VERIFY DOCKER_CERT_PATH && \
        export DOCKER_HOST && \
        echo "Notice: Docker remote host running, setting DOCKER_HOST=$DOCKER_HOST.."
    fi
fi
