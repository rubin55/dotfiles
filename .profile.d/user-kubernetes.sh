#!/bin/bash

export_kubeconfig ()
{

    local KUBE_HOME="$HOME/.kube"
    local KUBE_CONFDIR="$KUBE_HOME/config.d"
    local LOCAL_CONF

    [[ ! -r "$KUBE_HOME" ]] && return

    # only mess with KUBECONFIG when config.d is present
    if [[ -x "$KUBE_CONFDIR" ]] ; then

        for LOCAL_CONF in $KUBE_HOME/config $KUBE_CONFDIR/*; do
            [[ -e $LOCAL_CONF ]] && KUBECONFIG="$KUBECONFIG:$LOCAL_CONF"
        done

        [[ -n "$KUBECONFIG" ]] && export KUBECONFIG
    fi

}


# read ~/.kube/config and ~/.kube/config.d/* and export in KUBECONFIG
export_kubeconfig
unset export_kubeconfig

alias kc="kubectl"
