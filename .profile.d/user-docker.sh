#!/bin/bash

# A Docker host I'm known to run from time to time.
DOCKER_HOST="tcp://172.17.1.16:2375"


# Check if minikube is available and if it's running first.
which minikube > /dev/null 2>&1
if [ $? == 0 ]; then
    minikube status | grep -qw 'apiserver: Running' && \
    eval $(minikube docker-env) && \
    echo "Notice: Minikube is running, setting up DOCKER_HOST=$DOCKER_HOST"
elif [ ! -z "$DOCKER_HOST" ]; then
    DOCKER_ADDR=$(sed 's|.*://\(.*\):.*|\1|' <<< "$DOCKER_HOST")
    DOCKER_PORT=$(sed 's|.*:\(.*\)|\1|' <<< "$DOCKER_HOST")

    if [ "$DOCKER_PORT" == 2376 ]; then
        DOCKER_TLS_VERIFY="1"
        DOCKER_CERT_PATH="/Users/rubin/.docker/certs"

        ping -c 1 -W 1 $DOCKER_ADDR > /dev/null 2>&1 && \
        export DOCKER_HOST DOCKER_TLS_VERIFY DOCKER_CERT_PATH && \
        echo "Notice: A Docker remote host is up, setting DOCKER_HOST=$DOCKER_HOST"
    else
        ping -c 1 -W 1 $DOCKER_ADDR > /dev/null 2>&1 && \
        unset DOCKER_TLS_VERIFY DOCKER_CERT_PATH && \
        export DOCKER_HOST && \
        echo "Notice: A Docker remote host is up, setting DOCKER_HOST=$DOCKER_HOST"
    fi
fi
