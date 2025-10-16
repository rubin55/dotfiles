# ~/.bash_aliases: various aliases for commonly used things.

# Alias for sudo to work with aliases.
alias sudo='sudo '

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
alias alacritty-theme='alacritty-theme.sh'
alias amqctl='amqctl.sh'
alias dstat='dool'
alias gnome-random-backgrounds='gnome-random-backgrounds.py'
alias helmster='helmster.sh'
alias jc='journalctl'
alias jcu='journalctl --user'
alias kc='kubectl'
alias open='opener.sh'
alias papirus-accent='papirus-accent.sh'
alias pgctl='pgctl.sh'
alias pick='colorpicker.sh'
alias proton-run='proton-run.sh'
alias pygmentize='pygmentize -f terminal'
alias rmqctl='rmqctl.sh'
alias session='session.sh'
alias sc='systemctl'
alias scu='systemctl --user'
alias sig='sig.sh'
alias st='subl -w'
alias tipi='tipi.py'
alias tracker='localsearch'
alias venv='python3 -m venv'

# Some aliases for fsharp.
alias fsc='fsc.sh'
alias fsharpc='fsc.sh'
alias fsi='dotnet fsi'
alias fsharpi='dotnet fsi'

# Editor helpers.
# need to fix emacs.sh to work with wayland mode emacs.
alias em='emacs -nw'
alias hx='helix'
alias nv='nvim'
alias vi='nvim'
alias zed='zeditor'
