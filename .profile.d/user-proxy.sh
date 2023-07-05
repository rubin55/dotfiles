#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p log.info os.platform path.append path.which || return
path.which sed || return

if [[ "$(os.platform)" == "linux" ]]; then

  # Check for a proxy env file on this host, source if yes.
  if [[ -e "$HOME/.proxy.env" ]]; then
    log.info "Found $HOME/.proxy.env, using it to configure the environment"
    source "$HOME/.proxy.env"
  fi

  # A helpful dictionary of known proxy environment variables.
  declare -A known_proxy_envvars=( \
    [no_proxy]="$no_proxy" \
    [ftp_proxy]="$ftp_proxy" \
    [http_proxy]="$http_proxy" \
    [https_proxy]="$https_proxy" \
    [NO_PROXY]="$NO_PROXY" \
    [FTP_PROXY]="$FTP_PROXY" \
    [HTTP_PROXY]="$HTTP_PROXY" \
    [HTTPS_PROXY]="$HTTPS_PROXY" \
  )

  # We start by assuming we have no proxies defined.
  declare -A detected_proxy_envvars=()

  # Well-known private subnets.
  declare -a mandatory_no_proxy_elements=( \
    'localhost' \
    '127.0.0.0/8' \
    '192.168.0.0/16' \
    '172.16.0.0/12' \
    '10.0.0.0/8' \
  )

  # (Re)set detected variables, unset obsolete capitalized variants.
  for proxy_envvar in "${!known_proxy_envvars[@]}"; do
    if [[ $proxy_envvar =~ [[:upper:]]  && ${known_proxy_envvars[${proxy_envvar}]} ]]; then
      log.warn "Ignoring capitalized proxy env-var: $proxy_envvar"
      unset "$proxy_envvar"
    elif [[ -n "${known_proxy_envvars[${proxy_envvar}]}" ]]; then
      log.info "Configuring detected proxy env-var: ${proxy_envvar}=${known_proxy_envvars[${proxy_envvar}]}"
      detected_proxy_envvars["${proxy_envvar}"]="${known_proxy_envvars[${proxy_envvar}]}"
      export "$proxy_envvar"
    fi
  done

  # Save old IFS in preparation of no_proxy magic.
  old_IFS=$IFS

  # Set IFS to comma and create an array of no_proxy elements from no_proxy string.
  IFS=, read -r -a no_proxy_array <<< "$no_proxy"

  # Set IFS to colon and use path.append to conditionally add mandatory elements.
  if [[ -n $no_proxy ]]; then
    log.info "Making sure no_proxy contains private subnet definitions"
    IFS=: no_proxy=$(path.append "${mandatory_no_proxy_elements[*]}" "${no_proxy_array[*]}" nocheck | sed 's|:|,|g')
    export no_proxy
  fi

  # Reset IFS.
  IFS=$old_IFS
fi

# Unset temporary variables.
unset known_proxy_envvars detected_proxy_envvars mandatory_no_proxy_elements no_proxy_array proxy_envvar private_subnet old_IFS
