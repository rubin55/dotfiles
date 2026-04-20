# Check if functions are loaded and if required executables are available.
type -p path.which || return

# Check if opencode is available.
path.which opencode || return


export OPENCODE_DISABLE_CLAUDE_CODE=1
export OPENCODE_DISABLE_CLAUDE_CODE_PROMPT=1
export OPENCODE_DISABLE_CLAUDE_CODE_SKILLS=1
export OPENCODE_DISABLE_EXTERNAL_SKILLS=1
export OPENCODE_DISABLE_LSP_DOWNLOAD=true
export OPENCODE_DISABLE_TERMINAL_TITLE=true
