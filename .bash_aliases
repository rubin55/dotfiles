# ~/.bash_aliases: various aliases for commonly used things.

# Some common ls/dir aliases.
alias dir='dir --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'

# Colorful greps.
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# Various commonly used commands.
alias amqctl='amqctl.sh'
alias helmster='helmster.sh'
alias kc='kubectl'
alias lein='lein.sh'
alias open='opener.sh'
alias pgctl='pgctl.sh'
alias pygmentize='pygmentize -f terminal'
alias rmqctl='rmqctl.sh'
alias session='session.sh'
alias tipi='tipi.py'
alias tracker='tracker3'
alias venv="python3 -m venv"

# Editor helpers.
alias em='emacs.sh'
alias emacs='emacs.sh'
alias vi='gvim.sh'
alias vim='vim.sh'
alias gvim='gvim.sh'