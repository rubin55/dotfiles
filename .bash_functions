# ~/.bash_functions: a convenient library of bash functions.

function log() {
  [[ -z $BASH_LOG_LEVEL ]] && active_log_level=INFO || active_log_level=$BASH_LOG_LEVEL
  declare -A levels=([DEBUG]=0 [INFO]=1 [WARN]=2 [ERROR]=3)
  local level="$1"
  local name="$2"
  [[ ${levels[$level]} ]] || return 1
  (( ${levels[$level]} < ${levels[$active_log_level]} )) && return 2
  shift 2
  echo "[${level}] ${name}: ${*}" >&2
}

function log.info() {
  local name="${FUNCNAME[1]}"
  [[ $name == 'source' ]] && name="$(basename ${BASH_SOURCE[1]})"
  log INFO "$name" "$*"
}

function log.warn() {
  local name="${FUNCNAME[1]}"
  [[ $name == 'source' ]] && name="$(basename ${BASH_SOURCE[1]})"
  log WARN "$name" "$*"
}

function log.error() {
  local name="${FUNCNAME[1]}"
  [[ $name == 'source' ]] && name="$(basename ${BASH_SOURCE[1]})"
  log ERROR "$name" "$*"
}

function log.debug() {
  local name="${FUNCNAME[1]}"
  [[ $name == 'source' ]] && name="$(basename ${BASH_SOURCE[1]})"
  log DEBUG "$name" "$*"
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
  echo "$*" | sed -e 's#^:##; s#//*#/#g; s#::*#:#g; s#/\(:\|$\)#\1#g'
}

function path.append() {
  local IFS=:
  local source_path=($(path.sanitize "$1"))
  local target_path=($(path.sanitize "$2"))
  local bad_elements=()

  [[ -z $target_path ]] && log.warn "Target path empty, function will return source path"

  for element in "${source_path[@]}"; do
		if [[ $element && -d $element ]]; then
		target_path+=($element)
	else
		bad_elements+=($element)
	fi
  done

  if [[ -n $bad_elements ]]; then
    log.debug "Ignoring non-(existing)-directory elements: $(array.join , "${bad_elements[@]}")"
  fi

  echo "${target_path[*]}"
}

function os.platform() {
  [[ "$(uname -r)" =~ "icrosoft" ]] && echo windows || uname -s | tr '[:upper:]' '[:lower:]'
}

function net.port-open() {
  local host="$1"
  local port="$2"
  nmap --max-retries 0 --host-timeout 100ms "$host" -p "$port" -T5 -oG - | grep -q "Host: $host\|Ports: $port/open"
}

function title() {
  [[ -z "$orig" ]] && orig="$PS1"
  local title="\[\e]2;$*\a\]"
  PS1="${orig}${title}";
}

function prompt() {
  local git=$(which git 2> /dev/null)
  local git_prompt=$(which git-prompt.sh 2> /dev/null)
  local svn=$(which svn 2>/dev/null)
  local svn_prompt=$(which svn-prompt.sh 2> /dev/null)
  local s
  if [[ -n "$git" && -n "$git_prompt" ]]; then
    source "$git_prompt"
    s="$(__git_ps1 ' (%s)')"
  elif [[ -n "$svn" && -n "$svn_prompt" ]]; then
    svn info > /dev/null 2>&1
    if [[ $? = 0 ]] ; then
      source "$svn_prompt"
      s="$(__svn_ps1 ' (%s)')"
    fi
  fi

  echo -n "$s"
}

function man() {
  LESS_TERMCAP_md=$'\e[01;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[45;93m' \
  LESS_TERMCAP_se=$'\e[0m' \
  command man "$@"
}
