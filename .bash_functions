# ~/.bash_functions: a convenient library of bash functions.

function log() {
  #echo "f: ${FUNCNAME[@]}" > /tmp/f.out
  #echo "b: ${BASH_SOURCE[@]}" > /tmp/b.out
  [[ -z $BASH_LOG_LEVEL ]] && active_log_level=INFO || active_log_level=$BASH_LOG_LEVEL
  declare -A levels=([DEBUG]=0 [INFO]=1 [WARN]=2 [ERROR]=3)
  local level="$1"
  if [[ "${FUNCNAME[2]}" == 'source' ]]; then
      local name="$(basename ${BASH_SOURCE[2]})"
  elif [[ "${BASH_SOURCE[3]}" ]]; then
      local name="$(basename ${BASH_SOURCE[3]})"
  else
      local name="$(basename ${FUNCNAME[-1]})"
  fi
  [[ ${levels[$level]} ]] || return 1
  (( ${levels[$level]} < ${levels[$active_log_level]} )) && return 2
  shift 1
  echo "[${level}] ${name}: ${*}" >&2
}

function log.info() {
  log INFO "$*"
}

function log.warn() {
  log WARN "$*"
}

function log.error() {
  log ERROR "$*"
}

function log.debug() {
  log DEBUG "$*"
}

function array.join() {
  local IFS=$1
  shift
  echo "$*"
}

function path.which() {
  local IFS=,
  local executables=($1)
  local path="$(path.sanitize "$2")"
  local which="$(which which)"
  [[ $path ]] && local PATH=$path
  $which ${executables[@]} > /dev/null 2>&1
}

function path.sanitize() {
  local IFS=:
  local filtered=$(echo "$*" | sed -e 's#^:##; s#//*#/#g; s#::*#:#g; s#/\(:\|$\)#\1#g')
  local memory=()
  read -r -a array <<< "$filtered"

  for element in "${array[@]}"; do
    if [[ ! " ${memory[@]} " =~ " ${element} " ]]; then
      log.debug "I have no memory of '$element', adding to memory: ${memory[*]}"
      memory+=($element)
    else
      log.debug "I do have memory of '$element', not adding to memory: ${memory[*]}"
    fi
  done

  echo "${memory[*]}"
}

function path.append() {
  local IFS=:
  local source_path=($(path.sanitize "$1"))
  local target_path=($(path.sanitize "$2"))
  local no_check="$3"
  local bad_elements=()

  if [[ -z $target_path ]]; then
    log.debug "Target path empty, function will return source path: ${source_path[*]}"
  fi

  for element in "${source_path[@]}"; do
    if [[ ! " ${target_path[@]} " =~ " ${element} " ]]; then
      if [[ $no_check ]]; then
        log.debug "I don't have '$element' yet, adding to target: ${target_path[*]}"
        target_path+=($element)
      elif [[ $element && -e $element ]]; then
        log.debug "I don't have '$element' yet, adding to target: ${target_path[*]}"
        target_path+=($element)
      else
        bad_elements+=($element)
      fi
    else
      log.debug "I have '$element' already, not adding to target: ${target_path[*]}"
    fi
  done

  if [[ -n $bad_elements ]]; then
    log.debug "Ignoring non-existing elements: $(array.join , "${bad_elements[@]}")"
  fi

  echo "${target_path[*]}"
}

function os.platform() {
  [[ "$(uname -r)" =~ "icrosoft" ]] && echo windows || uname -s | tr '[:upper:]' '[:lower:]'
}

function net.port-open() {
  local host="$1"
  local port="$2"
  [[ "$(os.platform)" == "windows" ]] && local nmap=nmap.exe || local nmap=nmap
  "$nmap" --max-retries 0 --host-timeout 100ms "$host" -p "$port" -T5 -oG - | grep -q "Host: $host\|Ports: $port/open"
}

function title.set() {
  [[ -z "$orig" ]] && orig="$PS1"
  local code="\e]2;$*\a"
  local string="\[$code\]"
  echo -e "${code}";
  PS1="${orig}${string}";
}

function title.case() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | awk '{for(j=1;j<=NF;j++){ $j=toupper(substr($j,1,1)) substr ($j,2) }}1'
}

function host.short-name() {
  hostname | cut -d '.' -f 1
}

function openvpn.connect() {
  local conf="$1"
  local user="$2"
  if path.which sudo,openvpn && [[ -e "$conf" && -n "$user" ]]; then
    log.info "Setting up OpenVPN connection using: $conf, connecting as: $user"
    sudo -E -- sh -c "openvpn --config '$conf' --auth-user-pass <(echo '$user')"
  else
    log.error "Something went wrong: conf=$conf user=$user"
    return 1
  fi
}

function count.down() {
  local seconds=$1
  while [ $seconds -gt 0 ]; do
    echo -ne "$seconds\033[0K\r"
    sleep 1
    : $((seconds--))
  done
}
