#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.append path.which || return
path.which find,sort || return

# Construct KUBECONFIG_NEW.
if [[ -d "$HOME/.kube/config.d" ]]; then
  for config in $(find "$HOME/.kube/config.d" -type f | sort); do
    KUBECONFIG_NEW+="$config:"
  done
fi

# Add detected kube config files (if any) to KUBECONFIG.
if [[ -n "$KUBECONFIG_NEW" ]]; then
  export KUBECONFIG="$(path.append "$KUBECONFIG_NEW" "$KUBECONFIG")"
fi

# Unset temporary variables.
unset KUBECONFIG_NEW config
