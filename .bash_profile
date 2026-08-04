# ~/.bash_profile: executed by bash(1) for login shells.

[ -z "$PS1" ] && return

# Source .bashrc if it exists.
if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
