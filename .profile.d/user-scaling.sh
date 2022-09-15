#!/bin/bash

runScaling() {
    platform=$(uname -s | tr '[:upper:]' '[:lower:]')
    if [[ "$platform" == "linux" ]]; then

        # Example ~/.fontsizes:
        # codeMono=15
        # emacsMono=15
        # emacsSans=15
        # gnomeMono=11
        # gnomeSans=10
        # gnomeSerif=10
        # jetbrainsMono=14
        # vimMono=11

        # Check if $FONT_SIZE_PREFERENCES_FILE was set
        # else set a it to ~/.fontsizes by default.
        if [[ -n "$FONT_SIZE_PREFERENCES_FILE" && -e "$FONT_SIZE_PREFERENCES_FILE" ]]; then
            echo "Notice: Configuring font size preferences from \"$FONT_SIZE_PREFERENCES_FILE\".."
        else
            # Just use the default and don't tell us about it.
            FONT_SIZE_PREFERENCES_FILE="$HOME/.fontsizes"
        fi

        # Source $FONT_SIZE_PREFERENCES_FILE if it exists
        # else abort.
        if [[ -e "$FONT_SIZE_PREFERENCES_FILE" ]]; then
            source "$FONT_SIZE_PREFERENCES_FILE"
        else
            return
        fi

        # Current and wanted Visual Studio Code settings.
        codeConfig="$HOME/.config/Code/User/settings.json"
        if [[ -e "$codeConfig" && -n "$codeMono" ]]; then
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
        if [[ -e "$emacsConfig" && -n "$emacsMono" && -n "$emacsSans" ]]; then
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
        if [[ ! -z "$(which gsettings 2> /dev/null)" && -n "$gnomeMono" && -n "$gnomeSans" && -n "$gnomeSerif" ]]; then
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

        # Current and wanted JetBrains IDE settings.
        jetbrainsConfigs="$(find "$HOME/.config/JetBrains" -type f -name editor-font.xml 2> /dev/null)"
        for jetbrainsConfig in $jetbrainsConfigs; do
            if [[ -e "$jetbrainsConfig" && -n "$jetbrainsMono" ]]; then
            currentJetbrainsMonoFontName="$(xmllint --xpath '//application/component/option[@name="FONT_FAMILY"][@value]/@value' "$jetbrainsConfig" 2> /dev/null | awk -F'[="]' '!/>/{print $(NF-1)}')"
            currentJetbrainsMonoFontSize="$(xmllint --xpath '//application/component/option[@name="FONT_SIZE"][@value]/@value' "$jetbrainsConfig" 2> /dev/null | awk -F'[="]' '!/>/{print $(NF-1)}')"
            wantedJetbrainsMonoFontName="PragmataPro Mono"
            wantedJetbrainsMonoFontSize="$jetbrainsMono"

            # Update JetBrains config if different.
            if [[ "$currentJetbrainsMonoFontSize" && "$currentJetbrainsMonoFontSize" != "$wantedJetbrainsMonoFontSize" ]]; then
                echo "Notice: Setting $(echo $jetbrainsConfig | cut -d/ -f6) monospace font to \"$currentJetbrainsMonoFontName $wantedJetbrainsMonoFontSize\".."
                currentJetbrainsMonoFontNameString="name=\"FONT_FAMILY\" value=\"$currentJetbrainsMonoFontName\""
                wantedJetbrainsMonoFontNameString="name=\"FONT_FAMILY\" value=\"$wantedJetbrainsMonoFontName\""
                currentJetbrainsMonoFontSizeString="name=\"FONT_SIZE\" value=\"$currentJetbrainsMonoFontSize\""
                wantedJetbrainsMonoFontSizeString="name=\"FONT_SIZE\" value=\"$wantedJetbrainsMonoFontSize\""
                sed -i "s|$currentJetbrainsMonoFontNameString|$wantedJetbrainsMonoFontNameString|g" "$jetbrainsConfig"
                sed -i "s|$currentJetbrainsMonoFontSizeString|$wantedJetbrainsMonoFontSizeString|g" "$jetbrainsConfig"
            fi
        fi
        done

        # Current and wanted Vim settings.
        vimConfig="$HOME/.vimrc"
        if [[ -e "$vimConfig" && -n "$vimMono" ]]; then
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
