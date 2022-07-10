#!/bin/bash

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
        echo "Notice: A Docker remote host is up, setting DOCKER_HOST=$DOCKER_HOST.."
    elif [ "$DOCKER_PORT" == 2376 ]; then
        DOCKER_TLS_VERIFY="1"
        DOCKER_CERT_PATH="$HOME/.docker/certs"

        ping -c 1 -W 1 $DOCKER_ADDR > /dev/null 2>&1 && \
        export DOCKER_HOST DOCKER_TLS_VERIFY DOCKER_CERT_PATH && \
        echo "Notice: A Docker remote host is up, setting DOCKER_HOST=$DOCKER_HOST.."
    else
        ping -c 1 -W 1 $DOCKER_ADDR > /dev/null 2>&1 && \
        unset DOCKER_TLS_VERIFY DOCKER_CERT_PATH && \
        export DOCKER_HOST && \
        echo "Notice: A Docker remote host is up, setting DOCKER_HOST=$DOCKER_HOST.."
    fi
fi
