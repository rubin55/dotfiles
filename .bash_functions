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
  local exe
  [[ -n $2 ]] && local PATH="$(path.sanitize "$2")"
  for exe in "${executables[@]}"; do
    type -P "$exe" >/dev/null 2>&1 || return 1
  done
  return 0
}

function path.sanitize() {
  local input="$1"
  local -a parts
  local element joined=":" result=""

  IFS=: read -ra parts <<< "$input"

  for element in "${parts[@]}"; do
    [[ -z $element ]] && continue
    while [[ $element == *//* ]]; do
      element="${element//\/\//\/}"
    done
    while [[ ${#element} -gt 1 && $element == */ ]]; do
      element="${element%/}"
    done
    [[ $element == "/" ]] && continue
    case "$joined" in
      *":$element:"*) continue ;;
    esac
    result="${result:+$result:}$element"
    joined="$joined$element:"
  done

  echo "$result"
}

function path.append() {
  local source target no_check="$3"
  source="$(path.sanitize "$1")"
  target="$(path.sanitize "$2")"
  local -a parts
  local element joined=":$target:"
  local result="$target"

  IFS=: read -ra parts <<< "$source"

  for element in "${parts[@]}"; do
    case "$joined" in
      *":$element:"*) continue ;;
    esac
    if [[ -z $no_check && ! -e $element ]]; then
      continue
    fi
    result="${result:+$result:}$element"
    joined="$joined$element:"
  done

  echo "$result"
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

function vm.running() {
  local name="$1"
  virsh -c "qemu:///system" domstate "$name" | grep -q "running"
}

function title.set() {
  [[ -z "$orig" ]] && orig="$PS1"
  local code="\e]2;$*\a"
  local string="\[$code\]"
  echo -ne "${code}";
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
  trap 'echo; trap - SIGINT; return' SIGINT
  while [ $seconds -gt 0 ]; do
    echo -ne "$seconds\033[0K\r"
    sleep 1
    : $((seconds--))
  done
  echo 
  trap - SIGINT
}

function count.up() {
  local limit=$1
  local seconds=1
  trap 'echo; trap - SIGINT; return' SIGINT
  while [[ -z "$limit" || "$seconds" -le "$limit" ]]; do
    echo -ne "$seconds\033[0K\r"
    sleep 1
    : $((seconds++))
  done
  echo 
  trap - SIGINT
}
