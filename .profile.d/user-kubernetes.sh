#!/bin/bash


if [ -d "$HOME/.kube/config.d" ]; then
    unset KUBECONFIG
    for config in $(find "$HOME/.kube/config.d" -type f | sort); do
        KUBECONFIG+="$config:"
    done
fi

export KUBECONFIG
