#!/bin/bash

# When this network is handled by any gateway that's not default, you know we're connected.
CIDR='10.127.0.0/17'

# Check if CIDR is routed by default gateway.
route get $CIDR | grep -qw 'gateway: default'
if [ $? != 0 ]; then
    echo "Notice: Network $CIDR is available, configuring PGO"
    # Source PGO_SECRET_NAME, PGO_K8S_DOMAIN, PGO_INSTANCE, PGO_ADMIN_NS from ~/.pgorc
    [[ -s "$HOME/.pgorc" ]] && source "$HOME/.pgorc"

    # Set-up API server URL.
    PGO_TARGET_CLUSTER="$(kubectl config get-contexts | grep ^\* | awk '{print $3}')"
    PGO_APISERVER_URL="https://${PGO_INSTANCE}.${PGO_TARGET_CLUSTER}.${PGO_K8S_DOMAIN}"

    # Fetch username and password from admin namespace.
    PGOUSERNAME=$(kubectl get secret -n ${PGO_ADMIN_NS} ${PGO_SECRET_NAME} -o jsonpath='{.data.username}' | base64 --decode)
    PGOUSERPASS=$(kubectl get secret -n ${PGO_ADMIN_NS} ${PGO_SECRET_NAME} -o jsonpath='{.data.password}' | base64 --decode)

    # A few preferences.
    PGO_VERSION="4.3.2"
    DISABLE_TLS="true"

    # Export to environment.
    export PGO_APISERVER_URL PGOUSERNAME PGOUSERPASS PGO_VERSION DISABLE_TLS
fi
