# Check if functions are loaded and if required executables are available.
type -p path.which || return

# Check if gh is available.
path.which gh || return

export GH_TELEMETRY=false
