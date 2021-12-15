# .cshrc - csh resource script, read at beginning of execution by each shell


# A righteous umask
umask 22

# A sane default path
set path = (/sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin)

# Various defaults
setenv  CLICOLOR	1
setenv	EDITOR		vi
setenv	PAGER		more
setenv	BLOCKSIZE	K

# Various handy aliases
alias vi=vim

# An interactive shell
if ($?prompt) then
	set autolist
	set filec
	set history = 100
	set savehist = 100
	set mail = (/var/mail/$USER)
	if ( $?tcsh ) then
        setenv SHELL /bin/tcsh
		bindkey "^W" backward-delete-word
		bindkey -k up history-search-backward
		bindkey -k down history-search-forward
	endif
endif

# Add softimage globals
if ( -r ~/.xsi_7.5 ) then
    if ( $0 == xsishell ) then
        source ~/.xsi_7.5
    endif
endif

