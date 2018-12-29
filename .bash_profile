# ~/.bash_profile: executed by bash(1) for login shells.

# Set PKG_CONFIG_PATH.
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/lib/pkgconfig:/System/Library/Frameworks/Python.framework/Versions/2.7/lib/pkgconfig:/Applications/Xcode.app/Contents/Developer/usr/share/pkgconfig:$HOME/Applications/GnuTLS/gnutls36/lib/pkgconfig:$HOME/Applications/OpenSSL/openssl11/lib/pkgconfig:$HOME/Applications/Samba/samba44/lib/pkgconfig"

# Expand PATH with some local things.
export PATH="/Applications/CMake.app/Contents/bin:/Applications/Emacs.app/Contents/MacOS/bin:/Applications/MacVim.app/Contents/bin:/Applications/MKVToolNix.app/Contents/MacOS:/Applications/Postgres.app/Contents/Versions/latest/bin:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$HOME/.gem/ruby/2.3/bin:$HOME/.local/bin:$HOME/Applications/Ant/ant110/bin:$HOME/Applications/Autotools/autoconf2/bin:$HOME/Applications/Autotools/automake1/bin:$HOME/Applications/Bchunk/bchunk12/bin:$HOME/Applications/Corkscrew/corkscrew2/bin:$HOME/Applications/Ctags/ctags58/bin:$HOME/Applications/Dos2unix/d2u73/bin:$HOME/Applications/Forth/pforth28/bin:$HOME/Applications/GetText/gt019/bin:$HOME/Applications/GnuPG/gnupg22/bin:$HOME/Applications/GnuTLS/gnutls36/bin:$HOME/Applications/GotYourBack/gyb11:$HOME/Applications/Gradle/gradle46/bin:$HOME/Applications/Htop/htop22/bin:$HOME/Applications/Jenkins/jenkins2/bin:$HOME//Applications/Kubernetes/k8s112/bin:$HOME/Applications/Maven/maven36/bin:$HOME/Applications/MinGW/mingw-w32/bin:$HOME/Applications/MinGW/mingw-w64/bin:$HOME/Applications/Mono/mono512/bin:$HOME/Applications/Nmap/nmap76/bin:$HOME/Applications/OpenShift/os3/bin:$HOME/Applications/OpenSSL/openssl11/bin:$HOME/Applications/Oracle/instantclient122:$HOME/Applications/PkgConfig/pkgconfig029/bin:$HOME/Applications/Readline/rl7/bin:$HOME/Applications/Samba/samba44/bin:$HOME/Applications/Scheme/chez95/bin:$HOME/Applications/SCons/scons3/bin:$HOME/Library/Python/2.7/bin:$HOME/Syncthing/Source/RAAF/Scripts/python:$HOME/Syncthing/Source/RAAF/Scripts/shell:$PATH"

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

alias error=">&2 echo"

# I have my preference for PS1.
scm_ps1() {
    typeset s
    svn info > /dev/null 2>&1
    if [[ $? = 0 ]] ; then
        source $HOME/.local/bin/svn-prompt
        s="$(__svn_ps1 ' (%s)')"
    else
        source $HOME/.local/bin/git-prompt
        s="$(__git_ps1 ' (%s)')"
    fi

    echo -n "$s"
}

PS1='[\u@\h \[\033[01;94m\]\W\[\033[00;31m\]$(scm_ps1)\[\033[0m\]]\$ '

# Set the terminal title.
echo -ne "\033]0;Terminal\007"
