# Prefix ~/.local/bin to path if not in path already
PATH_NEW="$HOME/.local/bin:"

# Determine SOURCE_HOME.
SOURCE_HOMES="$HOME/Syncthing/Source $HOME/Source"
for POSSIBLE_SOURCE_HOME in $SOURCE_HOMES; do
    if [ -d "$POSSIBLE_SOURCE_HOME" ]; then
        SOURCE_HOME="$POSSIBLE_SOURCE_HOME"
        break
    fi
done

# Determine SCRIPTS_HOME.
SCRIPTS_HOMES="$SOURCE_HOME/Rubin/scripts $SOURCE_HOME/scripts"
for POSSIBLE_SCRIPTS_HOME in $SCRIPTS_HOMES; do
    if [ -d "$POSSIBLE_SCRIPTS_HOME" ]; then
        SCRIPTS_HOME="$POSSIBLE_SCRIPTS_HOME"
        break
    fi
done

# Some subdirectories I have in my SCRIPTS_HOME.
if [ -n "$SCRIPTS_HOME" ]; then
    for DIR in perl power python ruby shell; do
      PATH_NEW+="$SCRIPTS_HOME/$DIR:"
    done
fi

# Some other script directories I use here and there.
PATH_NEW+="/opt/jetbrains/scripts:$SOURCE_HOME/RAAF/session:$SOURCE_HOME/session:$SOURCE_HOME/ICTU/various/gitlab-getenv/bin:$SOURCE_HOME/gitlab-getenv/bin:$SOURCE_HOME/ICTU/various/helmster/bin:$SOURCE_HOME/helmster/bin"

# Do the path addition.
export PATH=$(path.append "$PATH_NEW" "$PATH")
