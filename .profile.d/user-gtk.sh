#!/bin/bash

if [ "$(uname -s)" == "Linux" ]; then
    if [[ "$XDG_SESSION_TYPE"  == "tty" ||  "$XDG_SESSION_TYPE"  == "x11" ]]; then
        export GDK_BACKEND=x11
    elif [[  "$XDG_SESSION_TYPE"  == "wayland" ]]; then
        export GDK_BACKEND=wayland,x11
    else
        export GDK_BACKEND=x11
    fi
    export GDK_SCALE=1
    export GDK_USE_XFT=1
    export GTK_THEME=Adwaita:dark
    export SAL_USE_VCLPLUGIN=gtk

    #if [[ -x /usr/bin/gsettings ]]; then
        # To find all similar keys on schema type following command:
        #gsettings list-recursively org.gnome.desktop.interface

        # To reset all valuses of keys run following command in terminal:
        #gsettings reset-recursively org.gnome.desktop.interface

        # Make sure that Gnomish GTK3+ stuff uses a sane font config.
        #gsettings set org.gnome.desktop.interface document-font-name 'Serif 12'
        #gsettings set org.gnome.desktop.interface font-name 'Sans 12'
        #gsettings set org.gnome.desktop.interface monospace-font-name 'Monospace 13'
    #fi
fi
