# shellcheck shell=bash
# ~/.bash_functions: a convenient library of bash functions.

declare -A LOG_LEVELS=([DEBUG]=0 [INFO]=1 [WARN]=2 [ERROR]=3)

function log() {
  local level="$1"
  [[ ${LOG_LEVELS[$level]} ]] || return 1
  local active_log_level="${BASH_LOG_LEVEL:-INFO}"
  (( ${LOG_LEVELS[$level]} < ${LOG_LEVELS[$active_log_level]} )) && return 2
  local name
  if [[ "${FUNCNAME[2]}" == 'source' ]]; then
    name="${BASH_SOURCE[2]##*/}"
  elif [[ "${BASH_SOURCE[3]}" ]]; then
    name="${BASH_SOURCE[3]##*/}"
  else
    name="${FUNCNAME[-1]##*/}"
  fi
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
  local -a executables
  read -ra executables <<< "$1"
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
  if [[ -z $_OS_PLATFORM ]]; then
    case "$OSTYPE" in
      linux*)
        local v=""
        [[ -r /proc/version ]] && read -r v < /proc/version
        if [[ "${v,,}" == *microsoft* ]]; then
          _OS_PLATFORM=windows
        else
          _OS_PLATFORM=linux
        fi
        ;;
      darwin*)       _OS_PLATFORM=darwin ;;
      cygwin*|msys*) _OS_PLATFORM=windows ;;
      freebsd*)      _OS_PLATFORM=freebsd ;;
      openbsd*)      _OS_PLATFORM=openbsd ;;
      netbsd*)       _OS_PLATFORM=netbsd ;;
      *)             _OS_PLATFORM="${OSTYPE%%[0-9.-]*}" ;;
    esac
  fi
  echo "$_OS_PLATFORM"
}

function host.short-name() {
  echo "${HOSTNAME%%.*}"
}

function net.port-open() {
  local host="$1"
  local port="$2"
  if [[ "$(os.platform)" == "windows" ]]; then
    local nmap=nmap.exe
  else
    local nmap=nmap
  fi
  "$nmap" --max-retries 0 --host-timeout 100ms "$host" -p "$port" -T5 -oG - \
    | grep -q "Host: $host\|Ports: $port/open"
}

function vm.running() {
  local name="$1"
  virsh -c "qemu:///system" domstate "$name" | grep -q "running"
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

function title.set() {
  [[ -z "$orig" ]] && orig="$PS1"
  local code="\e]2;$*\a"
  local string="\[$code\]"
  echo -ne "${code}" >&2;
  PS1="${orig}${string}";

  # Cache titles so title.append can work.
  local cache_dir="/tmp/terminal.titles"
  [[ -d "$cache_dir" ]] || { mkdir -p "$cache_dir"; chmod 700 "$cache_dir"; }
  local cache_file="$cache_dir/$$"
  rm -f "$cache_file"
  printf '%s\n' "$*" > "$cache_file"
  chmod 600 "$cache_file"
}

function title.append() {
  local f="/tmp/terminal.titles/$PPID"
  [[ -L "$f" || ! -f "$f" ]] && return 1
  local sz
  sz=$(stat -c%s "$f" 2>/dev/null) || return 1
  (( sz > 256 )) && return 1
  local base
  IFS= read -r base < "$f" || return 1
  title.set "$base$1"
}

function title.case() {
  local string="${1,,}"
  local result="" word
  for word in $string; do
    [[ -n $result ]] && result+=" "
    result+="${word^}"
  done
  echo "$result"
}

function title.line() {
  local title
  if [[ -n "$1" ]]; then title="-- $1 "; else title=""; fi
  local dashes="$(printf '%*s' $(($(tput cols)-${#title})) ''|tr ' ' -)"
  printf "\n\e[31m%s%s\e[0m\n\n" "$title" "$dashes"
}

function count.down() {
  local seconds=$1
  trap 'echo; trap - SIGINT; return' SIGINT
  while [ "$seconds" -gt 0 ]; do
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
