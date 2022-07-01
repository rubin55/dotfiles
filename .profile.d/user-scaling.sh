#!/bin/bash

runScaling() {
    platform=$(uname -s | tr '[:upper:]' '[:lower:]')
    if [[ "$platform" == "linux" ]]; then

        # Example ~/.fontsizes:
        # codeMono=15
        # emacsMono=15
        # emacsSans=15
        # vimMono=11
        # gnomeMono=11
        # gnomeSans=10
        # gnomeSerif=10

        # Check if $FONT_SIZE_PREFERENCES_FILE was set
        # else set a it to ~/.fontsizes by default.
        if [[ -z "$FONT_SIZE_PREFERENCES_FILE" ]]; then
            FONT_SIZE_PREFERENCES_FILE="$HOME/.fontsizes"
        fi

        # Source $FONT_SIZE_PREFERENCES_FILE if it exists
        # else abort.
        if [[ -e "$FONT_SIZE_PREFERENCES_FILE" ]]; then
            source "$FONT_SIZE_PREFERENCES_FILE"
        else
            return
        fi

        # Array of known desktop resolutions and related preferred font-sizes.
        declare -A settings=(
        [1920x1080]="codeMono=15,emacsMono=15,emacsSans=15,vimMono=11,gnomeMono=11,gnomeSans=10,gnomeSerif=10"
        [1920x1200]="codeMono=15,emacsMono=15,emacsSans=15,vimMono=11,gnomeMono=11,gnomeSans=10,gnomeSerif=10"
        [3840x1080]="codeMono=15,emacsMono=15,emacsSans=15,vimMono=11,gnomeMono=11,gnomeSans=10,gnomeSerif=10"
        [3840x1200]="codeMono=15,emacsMono=15,emacsSans=15,vimMono=11,gnomeMono=11,gnomeSans=10,gnomeSerif=10"
        [2560x1600]="codeMono=13,emacsMono=24,emacsSans=24,vimMono=13,gnomeMono=13,gnomeSans=11,gnomeSerif=11"
        [3840x2160]="codeMono=14,emacsMono=38,emacsSans=38,vimMono=14,gnomeMono=14,gnomeSans=13,gnomeSerif=13"
        [3840x2400]="codeMono=14,emacsMono=38,emacsSans=38,vimMono=14,gnomeMono=14,gnomeSans=13,gnomeSerif=13"
        )

        # Current and wanted Visual Studio Code settings.
        codeConfig="$HOME/.config/Code/User/settings.json"
        if [[ -e "$codeConfig" ]]; then
            currentCodeEditorFontName="$(grep "editor.fontFamily" "$codeConfig" | cut -d: -f2 | sed -e 's|"||g' -e 's|,||g' -e 's|^[[:space:]]*||g' -e 's|[[:space:]]*$||g')"
            currentCodeEditorFontSize="$(grep "editor.fontSize" "$codeConfig" | cut -d: -f2 | sed -e 's|"||g' -e 's|,||g' -e 's|^[[:space:]]*||g' -e 's|[[:space:]]*$||g')"
            currentCodeTerminalFontName="$(grep "terminal.integrated.fontFamily" "$codeConfig" | cut -d: -f2 | sed -e 's|"||g' -e 's|,||g' -e 's|^[[:space:]]*||g' -e 's|[[:space:]]*$||g')"
            currentCodeTerminalFontSize="$(grep "terminal.integrated.fontSize" "$codeConfig" | cut -d: -f2 | sed -e 's|"||g' -e 's|,||g' -e 's|^[[:space:]]*||g' -e 's|[[:space:]]*$||g')"
            wantedCodeEditorFontSize="$codeMono"
            wantedCodeTerminalFontSize="$wantedCodeEditorFontSize"

            # Update Visual Studio Code editor font if different.
            if [[ "$currentCodeEditorFontSize" != "$wantedCodeEditorFontSize" ]]; then
                echo "Notice: Setting Code editor font to \"$currentCodeEditorFontName $wantedCodeEditorFontSize\".."
                currentCodeEditorFontString="\"editor.fontSize\": $currentCodeEditorFontSize,"
                wantedCodeEditorFontString="\"editor.fontSize\": $wantedCodeEditorFontSize,"
                sed -i "s|$currentCodeEditorFontString|$wantedCodeEditorFontString|g" "$codeConfig"
            fi

            # Update Visual Studio Code terminal font if different.
            if [[ "$currentCodeTerminalFontSize" != "$wantedCodeTerminalFontSize" ]]; then
                echo "Notice: Setting Code terminal font to \"$currentCodeTerminalFontName $wantedCodeTerminalFontSize\".."
                currentCodeTerminalFontString="\"terminal.integrated.fontSize\": $currentCodeTerminalFontSize,"
                wantedCodeTerminalFontString="\"terminal.integrated.fontSize\": $wantedCodeTerminalFontSize,"
                sed -i "s|$currentCodeTerminalFontString|$wantedCodeTerminalFontString|g" "$codeConfig"
            fi
        fi

        # Current and wanted Emacs settings.
        emacsHostIdentifier="$(hostname | cut -d. -f1)"
        emacsConfig="$HOME/.doom.d/config.el"
        if [[ -e "$emacsConfig" ]]; then
            currentEmacsMonospaceFontName="$(grep -A1 "(when (string= (system-name) \"$emacsHostIdentifier\")" "$emacsConfig" | tail -n1 | awk -F ':' '{print $2}' \
                                    | cut -d' ' -f2 | sed -e "s|'||g" -e 's|"||g' -e "s|'||g" -e 's|"||g' -e 's|)||g')"
            currentEmacsMonospaceFontSize="$(grep -A1 "(when (string= (system-name) \"$emacsHostIdentifier\")" "$emacsConfig" | tail -n1 | awk -F ':' '{print $3}' \
                                    | cut -d' ' -f2 | sed -e "s|'||g" -e 's|"||g' -e "s|'||g" -e 's|"||g' -e 's|)||g')"
            currentEmacsVariablewidthFontName="$(grep -A2 "(when (string= (system-name) \"$emacsHostIdentifier\")" "$emacsConfig" | tail -n1 | awk -F ':' '{print $2}' \
                                    | cut -d' ' -f2 | sed -e "s|'||g" -e 's|"||g' -e "s|'||g" -e 's|"||g' -e 's|)||g')"
            currentEmacsVariablewidthFontSize="$(grep -A2 "(when (string= (system-name) \"$emacsHostIdentifier\")" "$emacsConfig" | tail -n1 | awk -F ':' '{print $3}' \
                                    | cut -d' ' -f2 | sed -e "s|'||g" -e 's|"||g' -e "s|'||g" -e 's|"||g' -e 's|)||g')"
            wantedEmacsMonospaceFontSize="$emacsMono"
            wantedEmacsVariablewidthFontSize="$emacsSans"

            # Update Emacs monospace font if different.
            if [[ "$currentEmacsMonospaceFontSize" != "$wantedEmacsMonospaceFontSize" ]]; then
                echo "Notice: Setting Emacs monospace font to \"$currentEmacsMonospaceFontName $wantedEmacsMonospaceFontSize\".."
                currentEmacsMonospaceFontString="$(grep -A1 "(when (string= (system-name) \"$emacsHostIdentifier\")" "$emacsConfig" | tail -n1)"
                currentEmacsMonospaceFontLineNumber="$(grep -n -A1 "(when (string= (system-name) \"$emacsHostIdentifier\")" "$emacsConfig" | tail -n1 | cut -d- -f1)"
                wantedEmacsMonospaceFontString="$(echo "$currentEmacsMonospaceFontString" | sed "s|:size $currentEmacsMonospaceFontSize|:size $wantedEmacsMonospaceFontSize|")"
                sed -i "${currentEmacsMonospaceFontLineNumber}s|$currentEmacsMonospaceFontString|$wantedEmacsMonospaceFontString|" "$emacsConfig"
            fi

            # Update Emacs variable-width font if different.
            if [[ "$currentEmacsVariablewidthFontSize" != "$wantedEmacsVariablewidthFontSize" ]]; then
                echo "Notice: Setting Emacs variable-width font to \"$currentEmacsVariablewidthFontName $wantedEmacsVariablewidthFontSize\".."
                currentEmacsVariablewidthFontString="$(grep -A2 "(when (string= (system-name) \"$emacsHostIdentifier\")" "$emacsConfig" | tail -n1)"
                currentEmacsVariablewidthFontLineNumber="$(grep -n -A2 "(when (string= (system-name) \"$emacsHostIdentifier\")" "$emacsConfig" | tail -n1 | cut -d- -f1)"
                wantedEmacsVariablewidthFontString="$(echo "$currentEmacsVariablewidthFontString" | sed "s|:size $currentEmacsVariablewidthFontSize|:size $wantedEmacsVariablewidthFontSize|")"
                sed -i "${currentEmacsVariablewidthFontLineNumber}s|$currentEmacsVariablewidthFontString|$wantedEmacsVariablewidthFontString|" "$emacsConfig"
            fi
        fi

        # Current and wanted Gnome system settings.
        if [[ ! -z "$(which gsettings 2> /dev/null)" ]]; then
            currentGnomeMonospaceFontName="$(gsettings get org.gnome.desktop.interface monospace-font-name | sed -e "s|'||g" -e 's|[0-9]||g' -e 's|[[:space:]]*$||g')"
            currentGnomeMonospaceFontSize="$(gsettings get org.gnome.desktop.interface monospace-font-name | sed -e "s|'||g" | awk -F ' ' '{print $NF}')"
            currentGnomeInterfaceFontName="$(gsettings get org.gnome.desktop.interface font-name | sed -e "s|'||g" -e 's|[0-9]||g' -e 's|[[:space:]]*$||g')"
            currentGnomeInterfaceFontSize="$(gsettings get org.gnome.desktop.interface font-name | sed -e "s|'||g" | awk -F ' ' '{print $NF}')"
            currentGnomeDocumentFontName="$(gsettings get org.gnome.desktop.interface document-font-name | sed -e "s|'||g" -e 's|[0-9]||g' -e 's|[[:space:]]*$||g')"
            currentGnomeDocumentFontSize="$(gsettings get org.gnome.desktop.interface document-font-name | sed -e "s|'||g" | awk -F ' ' '{print $NF}')"
            currentGnomeTitleFontName="$(gsettings get org.gnome.desktop.wm.preferences titlebar-font | sed -e "s|'||g" -e 's|[0-9]||g' -e 's|[[:space:]]*$||g')"
            currentGnomeTitleFontSize="$(gsettings get org.gnome.desktop.wm.preferences titlebar-font | sed -e "s|'||g" | awk -F ' ' '{print $NF}')"
            wantedGnomeMonospaceFontSize="$gnomeMono"
            wantedGnomeInterfaceFontSize="$gnomeSans"
            wantedGnomeDocumentFontSize="$gnomeSerif"
            wantedGnomeTitleFontSize="$wantedGnomeInterfaceFontSize"

            # Update Gnome system monospace font if different.
            if [[ "$currentGnomeMonospaceFontSize" != "$wantedGnomeMonospaceFontSize" ]]; then
                echo "Notice: Setting Gnome monospace font to \"$currentGnomeMonospaceFontName $wantedGnomeMonospaceFontSize\".."
                gsettings set org.gnome.desktop.interface monospace-font-name "$currentGnomeMonospaceFontName $wantedGnomeMonospaceFontSize" > /dev/null 2>&1
            fi

            # Update Gnome system interface font if different.
            if [[ "$currentGnomeInterfaceFontSize" != "$wantedGnomeInterfaceFontSize" ]]; then
                echo "Notice: Setting Gnome interface font to \"$currentGnomeInterfaceFontName $wantedGnomeInterfaceFontSize\".."
                gsettings set org.gnome.desktop.interface font-name "$currentGnomeInterfaceFontName $wantedGnomeInterfaceFontSize" > /dev/null 2>&1
            fi

            # Update Gnome system document font if different.
            if [[ "$currentGnomeDocumentFontSize" != "$wantedGnomeDocumentFontSize" ]]; then
                echo "Notice: Setting Gnome document font to \"$currentGnomeDocumentFontName $wantedGnomeDocumentFontSize\".."
                gsettings set org.gnome.desktop.interface document-font-name "$currentGnomeDocumentFontName $wantedGnomeDocumentFontSize" > /dev/null 2>&1
            fi

            # Update Gnome system title font if different.
            if [[ "$currentGnomeTitleFontSize" != "$wantedGnomeTitleFontSize" ]]; then
                echo "Notice: Setting Gnome title font to \"$currentGnomeTitleFontName $wantedGnomeTitleFontSize\".."
                gsettings set org.gnome.desktop.wm.preferences titlebar-font "$currentGnomeTitleFontName $wantedGnomeTitleFontSize" > /dev/null 2>&1
            fi
        fi

        # Current and wanted Gnome theme settings.
        themeConfig="$HOME/.local/share/themes/Rubin/gnome-shell/gnome-shell.css"
        if [[ -e "$themeConfig" ]]; then
            currentGnomeThemeFontName="$(grep 'font-family:' "$themeConfig" | cut -d: -f2 | sed -e 's|;||' -e 's|^[[:space:]]*||g' -e 's|[[:space:]]*$||g')"
            currentGnomeThemeFontSize="$(grep 'font-size:' "$themeConfig" | cut -d: -f2 | sed -e 's|;||' -e 's|^[[:space:]]*||g' -e 's|[[:space:]]*$||g')"
            wantedGnomeThemeFontSize="${wantedGnomeInterfaceFontSize}pt"

            # Update Gnome theme config if different.
            if [[ "$currentGnomeThemeFontSize" != "$wantedGnomeThemeFontSize" ]]; then
                echo "Notice: Setting Gnome theme font to \"$currentGnomeThemeFontName $wantedGnomeThemeFontSize\".."
                currentGnomeThemeFontString="font-size: $currentGnomeThemeFontSize;"
                wantedGnomeThemeFontString="font-size: $wantedGnomeThemeFontSize;"
                sed -i "s|$currentGnomeThemeFontString|$wantedGnomeThemeFontString|g" "$themeConfig"
                gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'Main.loadTheme();' > /dev/null 2>&1
            fi
        fi

        # Current and wanted Vim settings.
        vimConfig="$HOME/.vimrc"
        if [[ -e "$vimConfig" ]]; then
            currentVimMonoFontName="$(grep -A1 "if has('gui_gtk3')" "$vimConfig" | tail -n1 | cut -d= -f2 | sed -e 's|\\||g' -e 's|[0-9]||g' -e 's|[[:space:]]*$||g')"
            currentVimMonoFontSize="$(grep -A1 "if has('gui_gtk3')" "$vimConfig" | tail -n1 | cut -d= -f2 | awk -F '\\\\ ' '{print $NF}')"
            wantedVimMonoFontSize="$vimMono"

            # Update Vim config if different.
            if [[ "$currentVimMonoFontSize" != "$wantedVimMonoFontSize" ]]; then
                echo "Notice: Setting Vim monospace font to \"$currentVimMonoFontName $wantedVimMonoFontSize\".."
                currentVimMonoFontString="set guifont=$(echo "$currentVimMonoFontName $currentVimMonoFontSize" | sed 's| |\\\\ |g')"
                wantedVimMonoFontString="set guifont=$(echo "$currentVimMonoFontName $wantedVimMonoFontSize" | sed 's| |\\\\ |g')"
                sed -i "s|$currentVimMonoFontString|$wantedVimMonoFontString|g" "$vimConfig"
            fi
        fi
    fi
}

runScaling
