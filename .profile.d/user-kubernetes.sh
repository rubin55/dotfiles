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

# Set a shorter alias for kubectl.
alias kc='kubectl'

# Add completion support to bash, cached in /tmp (regenerated each boot).
KUBECTL_COMPLETION_CACHE=/tmp/kubectl-completion.bash
if [[ ! -f $KUBECTL_COMPLETION_CACHE ]]; then
  kubectl completion bash > "$KUBECTL_COMPLETION_CACHE"
fi
source "$KUBECTL_COMPLETION_CACHE"
complete -F __start_kubectl kc
unset KUBECTL_COMPLETION_CACHE

# Unset temporary variables.
unset KUBECONFIG_NEW config
