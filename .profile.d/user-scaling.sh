#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p log.info os.platform path.which || return
path.which awk,cut,find,grep,gsettings,hostname,sed,xmllint || return

# Check if we have a timer file that's at least a day old.
if [[ ! -z "$(find /tmp/user-scaling.timer -mtime +1 -print 2> /dev/null)" ]]; then
  log.debug "Removing expired timer file: /tmp/user-scaling.timer"
  rm -f /tmp/user-scaling.timer
fi

# Run the scaling routines if we're on linux and don't have a timer file.
if [[ "$(os.platform)" == "linux" && ! -e /tmp/user-scaling.timer ]]; then

  # Example ~/.fontsizes:
  # codeMono=15
  # emacsMono=15
  # emacsSans=15
  # gnomeMono=11
  # gnomeSans=10
  # gnomeSerif=10
  # jetbrainsMono=14
  # vimMono=11
  # qt5Mono=11
  # qt5Sans=10
  # qt6Mono=11
  # qt6Sans=10

  # Check if $FONT_SIZE_PREFERENCES_FILE was set
  # else set a it to ~/.fontsizes by default.
  if [[ -n "$FONT_SIZE_PREFERENCES_FILE" && -e "$FONT_SIZE_PREFERENCES_FILE" ]]; then
    log.info "Configuring font size preferences from: \"$FONT_SIZE_PREFERENCES_FILE\""
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
      log.info "Setting Code editor font to: \"$currentCodeEditorFontName $wantedCodeEditorFontSize\""
      currentCodeEditorFontString="\"editor.fontSize\": $currentCodeEditorFontSize,"
      wantedCodeEditorFontString="\"editor.fontSize\": $wantedCodeEditorFontSize,"
      sed -i "s|$currentCodeEditorFontString|$wantedCodeEditorFontString|g" "$codeConfig"
    fi

    # Update Visual Studio Code terminal font if different.
    if [[ "$currentCodeTerminalFontSize" != "$wantedCodeTerminalFontSize" ]]; then
      log.info "Setting Code terminal font to: \"$currentCodeTerminalFontName $wantedCodeTerminalFontSize\""
      currentCodeTerminalFontString="\"terminal.integrated.fontSize\": $currentCodeTerminalFontSize,"
      wantedCodeTerminalFontString="\"terminal.integrated.fontSize\": $wantedCodeTerminalFontSize,"
      sed -i "s|$currentCodeTerminalFontString|$wantedCodeTerminalFontString|g" "$codeConfig"
    fi
  fi

  # Current and wanted Emacs settings.
  emacsConfig="$HOME/.doom.d/config.el"
  emacsHostIdentifier="$(hostname | cut -d. -f1)"
  emacsHostIdentifierInConfigMonospace="$(grep -A1 "(when (string= (system-name) \"$emacsHostIdentifier\")" "$emacsConfig" | tail -n1)"
  emacsHostIdentifierInConfigVariablewidth="$(grep -A2 "(when (string= (system-name) \"$emacsHostIdentifier\")" "$emacsConfig" | tail -n1)"
  if [[ -e "$emacsConfig" && -n "$emacsHostIdentifier" && -n "$emacsHostIdentifierInConfigMonospace" && -n "$emacsHostIdentifierInConfigVariablewidth" && -n "$emacsMono" && -n "$emacsSans" ]]; then
    currentEmacsMonospaceFontName="$(echo "$emacsHostIdentifierInConfigMonospace" | awk -F ':' '{print $2}' \
                | cut -d' ' -f2 | sed -e "s|'||g" -e 's|"||g' -e 's|)||g')"
    currentEmacsMonospaceFontSize="$(echo "$emacsHostIdentifierInConfigMonospace" | awk -F ':' '{print $3}' \
                | cut -d' ' -f2 | sed -e "s|'||g" -e 's|"||g' -e 's|)||g')"
    currentEmacsVariablewidthFontName="$(echo "$emacsHostIdentifierInConfigVariablewidth" | awk -F ':' '{print $2}' \
                | cut -d' ' -f2 | sed -e "s|'||g" -e 's|"||g' -e 's|)||g')"
    currentEmacsVariablewidthFontSize="$(echo "$emacsHostIdentifierInConfigVariablewidth" | awk -F ':' '{print $3}' \
                | cut -d' ' -f2 | sed -e "s|'||g" -e 's|"||g' -e 's|)||g')"
    wantedEmacsMonospaceFontSize="$emacsMono"
    wantedEmacsVariablewidthFontSize="$emacsSans"

    # Update Emacs monospace font if different.
    if [[ "$currentEmacsMonospaceFontSize" != "$wantedEmacsMonospaceFontSize" ]]; then
      log.info "Setting Emacs monospace font to: \"$currentEmacsMonospaceFontName $wantedEmacsMonospaceFontSize\""
      currentEmacsMonospaceFontString="$(grep -A1 "(when (string= (system-name) \"$emacsHostIdentifier\")" "$emacsConfig" | tail -n1)"
      currentEmacsMonospaceFontLineNumber="$(grep -n -A1 "(when (string= (system-name) \"$emacsHostIdentifier\")" "$emacsConfig" | tail -n1 | cut -d- -f1)"
      wantedEmacsMonospaceFontString="$(echo "$currentEmacsMonospaceFontString" | sed "s|:size $currentEmacsMonospaceFontSize|:size $wantedEmacsMonospaceFontSize|")"
      sed -i "${currentEmacsMonospaceFontLineNumber}s|$currentEmacsMonospaceFontString|$wantedEmacsMonospaceFontString|" "$emacsConfig"
    fi

    # Update Emacs variable-width font if different.
    if [[ "$currentEmacsVariablewidthFontSize" != "$wantedEmacsVariablewidthFontSize" ]]; then
      log.info "Setting Emacs variable-width font to: \"$currentEmacsVariablewidthFontName $wantedEmacsVariablewidthFontSize\""
      currentEmacsVariablewidthFontString="$(grep -A2 "(when (string= (system-name) \"$emacsHostIdentifier\")" "$emacsConfig" | tail -n1)"
      currentEmacsVariablewidthFontLineNumber="$(grep -n -A2 "(when (string= (system-name) \"$emacsHostIdentifier\")" "$emacsConfig" | tail -n1 | cut -d- -f1)"
      wantedEmacsVariablewidthFontString="$(echo "$currentEmacsVariablewidthFontString" | sed "s|:size $currentEmacsVariablewidthFontSize|:size $wantedEmacsVariablewidthFontSize|")"
      sed -i "${currentEmacsVariablewidthFontLineNumber}s|$currentEmacsVariablewidthFontString|$wantedEmacsVariablewidthFontString|" "$emacsConfig"
    fi
  fi

  # Current and wanted Gnome system settings.
  if [[ ! -z "$(which gsettings 2> /dev/null)" && -n "$gnomeMono" && -n "$gnomeSans" && -n "$gnomeSerif" ]]; then
    currentGnomeMonospaceFontName="$(gsettings get org.gnome.desktop.interface monospace-font-name | sed -e "s|'||g" -e 's|\s[^\s]*$||' -e 's|\s*$||g')"
    currentGnomeMonospaceFontSize="$(gsettings get org.gnome.desktop.interface monospace-font-name | sed -e "s|'||g" -e 's/.*\s\([^ ]*\)$/\1/')"
    currentGnomeInterfaceFontName="$(gsettings get org.gnome.desktop.interface font-name           | sed -e "s|'||g" -e 's|\s[^\s]*$||' -e 's|\s*$||g')"
    currentGnomeInterfaceFontSize="$(gsettings get org.gnome.desktop.interface font-name           | sed -e "s|'||g" -e 's/.*\s\([^ ]*\)$/\1/')"
    currentGnomeDocumentFontName="$(gsettings get org.gnome.desktop.interface document-font-name   | sed -e "s|'||g" -e 's|\s[^\s]*$||' -e 's|\s*$||g')"
    currentGnomeDocumentFontSize="$(gsettings get org.gnome.desktop.interface document-font-name   | sed -e "s|'||g" -e 's/.*\s\([^ ]*\)$/\1/')"
    currentGnomeTitleFontName="$(gsettings get org.gnome.desktop.wm.preferences titlebar-font      | sed -e "s|'||g" -e 's|\s[^\s]*$||' -e 's|\s*$||g')"
    currentGnomeTitleFontSize="$(gsettings get org.gnome.desktop.wm.preferences titlebar-font      | sed -e "s|'||g" -e 's/.*\s\([^ ]*\)$/\1/')"
    wantedGnomeMonospaceFontSize="$gnomeMono"
    wantedGnomeInterfaceFontSize="$gnomeSans"
    wantedGnomeDocumentFontSize="$gnomeSerif"
    wantedGnomeTitleFontSize="$wantedGnomeInterfaceFontSize"

    # Update Gnome system monospace font if different.
    if [[ "$currentGnomeMonospaceFontSize" != "$wantedGnomeMonospaceFontSize" ]]; then
      log.info "Setting Gnome monospace font to: \"$currentGnomeMonospaceFontName $wantedGnomeMonospaceFontSize\""
      gsettings set org.gnome.desktop.interface monospace-font-name "$currentGnomeMonospaceFontName $wantedGnomeMonospaceFontSize" > /dev/null 2>&1
    fi

    # Update Gnome system interface font if different.
    if [[ "$currentGnomeInterfaceFontSize" != "$wantedGnomeInterfaceFontSize" ]]; then
      log.info "Setting Gnome interface font to: \"$currentGnomeInterfaceFontName $wantedGnomeInterfaceFontSize\""
      gsettings set org.gnome.desktop.interface font-name "$currentGnomeInterfaceFontName $wantedGnomeInterfaceFontSize" > /dev/null 2>&1
    fi

    # Update Gnome system document font if different.
    if [[ "$currentGnomeDocumentFontSize" != "$wantedGnomeDocumentFontSize" ]]; then
      log.info "Setting Gnome document font to: \"$currentGnomeDocumentFontName $wantedGnomeDocumentFontSize\""
      gsettings set org.gnome.desktop.interface document-font-name "$currentGnomeDocumentFontName $wantedGnomeDocumentFontSize" > /dev/null 2>&1
    fi

    # Update Gnome system title font if different.
    if [[ "$currentGnomeTitleFontSize" != "$wantedGnomeTitleFontSize" ]]; then
      log.info "Setting Gnome title font to: \"$currentGnomeTitleFontName $wantedGnomeTitleFontSize\""
      gsettings set org.gnome.desktop.wm.preferences titlebar-font "$currentGnomeTitleFontName $wantedGnomeTitleFontSize" > /dev/null 2>&1
    fi
  fi

  # Current and wanted Gnome theme settings.
  #
  # Example theme file:
  #
  # @import url("resource:///org/gnome/theme/gnome-shell.css");
  #
  # stage {
  #   font-family: Sans Bold;
  #   font-size: 10pt;
  # }
  #
  themeConfig="$HOME/.local/share/themes/Custom/gnome-shell/gnome-shell.css"
  if [[ -e "$themeConfig" && -n "$wantedGnomeInterfaceFontSize" ]]; then
    currentGnomeThemeFontName="$(grep 'font-family:' "$themeConfig" | cut -d: -f2 | sed -e 's|;||' -e 's|^[[:space:]]*||g' -e 's|[[:space:]]*$||g' | head -n1)"
    currentGnomeThemeFontSize="$(grep 'font-size:' "$themeConfig" | cut -d: -f2 | sed -e 's|;||' -e 's|^[[:space:]]*||g' -e 's|[[:space:]]*$||g' | head -n1)"
    wantedGnomeThemeFontSize="${wantedGnomeInterfaceFontSize}pt"

    # Update Gnome theme config if different.
    if [[ "$currentGnomeThemeFontSize" != "$wantedGnomeThemeFontSize" ]]; then
      log.info "Setting Gnome theme font to: \"$currentGnomeThemeFontName $wantedGnomeThemeFontSize\""
      currentGnomeThemeFontString="font-size: $currentGnomeThemeFontSize;"
      wantedGnomeThemeFontString="font-size: $wantedGnomeThemeFontSize;"
      sed -i "s|$currentGnomeThemeFontString|$wantedGnomeThemeFontString|g" "$themeConfig"
      gsettings set org.gnome.shell.extensions.user-theme name Default
      gsettings set org.gnome.shell.extensions.user-theme name Custom
    fi
  fi

  # Current and wanted QT5 settings.
  qt5Config="$HOME/.config/qt5ct/qt5ct.conf"
  if [[ -e "$qt5Config" && -n "$qt5Mono" && "$qt5Sans" ]]; then
    currentQt5MonoFontName="$(grep 'fixed='   "$qt5Config" | cut -d \" -f 2 | cut -d , -f 1)"
    currentQt5MonoFontSize="$(grep 'fixed='   "$qt5Config" | cut -d \" -f 2 | cut -d , -f 2)"
    currentQt5SansFontName="$(grep 'general=' "$qt5Config" | cut -d \" -f 2 | cut -d , -f 1)"
    currentQt5SansFontSize="$(grep 'general=' "$qt5Config" | cut -d \" -f 2 | cut -d , -f 2)"
    wantedQt5MonoFontName="$currentQt5MonoFontName"
    wantedQt5MonoFontSize="$qt5Mono"
    wantedQt5SansFontName="$currentQt5SansFontName"
    wantedQt5SansFontSize="$qt5Sans"

    # Update QT5 general font settings if different.
    if [[ "$currentQt5SansFontSize" != "$wantedQt5SansFontSize" ]]; then
      log.info "Setting QT5 general font to: \"$wantedQt5SansFontName $wantedQt5SansFontSize\""
      currentQt5SansFontString="general=\"$currentQt5SansFontName,$currentQt5SansFontSize,"
      wantedQt5SansFontString="general=\"$wantedQt5SansFontName,$wantedQt5SansFontSize,"
      sed -i "s|$currentQt5SansFontString|$wantedQt5SansFontString|g" "$qt5Config"
    fi

    # Update QT5 fixed font settings if different.
    if [[ "$currentQt5MonoFontSize" != "$wantedQt5MonoFontSize" ]]; then
      log.info "Setting QT5 fixed font to: \"$wantedQt5MonoFontName $wantedQt5MonoFontSize\""
      currentQt5MonoFontString="fixed=\"$currentQt5MonoFontName,$currentQt5MonoFontSize,"
      wantedQt5MonoFontString="fixed=\"$wantedQt5MonoFontName,$wantedQt5MonoFontSize,"
      sed -i "s|$currentQt5MonoFontString|$wantedQt5MonoFontString|g" "$qt5Config"
    fi
  fi

  # Current and wanted QT6 settings.
  qt6Config="$HOME/.config/qt6ct/qt6ct.conf"
  if [[ -e "$qt6Config" && -n "$qt6Mono" && "$qt6Sans" ]]; then
    currentQt6MonoFontName="$(grep 'fixed='   "$qt6Config" | cut -d \" -f 2 | cut -d , -f 1)"
    currentQt6MonoFontSize="$(grep 'fixed='   "$qt6Config" | cut -d \" -f 2 | cut -d , -f 2)"
    currentQt6SansFontName="$(grep 'general=' "$qt6Config" | cut -d \" -f 2 | cut -d , -f 1)"
    currentQt6SansFontSize="$(grep 'general=' "$qt6Config" | cut -d \" -f 2 | cut -d , -f 2)"
    wantedQt6MonoFontName="$currentQt6MonoFontName"
    wantedQt6MonoFontSize="$qt6Mono"
    wantedQt6SansFontName="$currentQt6SansFontName"
    wantedQt6SansFontSize="$qt6Sans"

    # Update QT6 general font settings if different.
    if [[ "$currentQt6SansFontSize" != "$wantedQt6SansFontSize" ]]; then
      log.info "Setting QT6 general font to: \"$wantedQt6SansFontName $wantedQt6SansFontSize\""
      currentQt6SansFontString="general=\"$currentQt6SansFontName,$currentQt6SansFontSize,"
      wantedQt6SansFontString="general=\"$wantedQt6SansFontName,$wantedQt6SansFontSize,"
      sed -i "s|$currentQt6SansFontString|$wantedQt6SansFontString|g" "$qt6Config"
    fi

    # Update QT6 fixed font settings if different.
    if [[ "$currentQt6MonoFontSize" != "$wantedQt6MonoFontSize" ]]; then
      log.info "Setting QT6 fixed font to: \"$wantedQt6MonoFontName $wantedQt6MonoFontSize\""
      currentQt6MonoFontString="fixed=\"$currentQt6MonoFontName,$currentQt6MonoFontSize,"
      wantedQt6MonoFontString="fixed=\"$wantedQt6MonoFontName,$wantedQt6MonoFontSize,"
      sed -i "s|$currentQt6MonoFontString|$wantedQt6MonoFontString|g" "$qt6Config"
    fi
  fi

  # Current and wanted JetBrains IDE settings.
  jetbrainsConfigs="$(find "$HOME/.config/JetBrains" -type f -name editor-font.xml 2> /dev/null)"
  for jetbrainsConfig in $jetbrainsConfigs; do
    if [[ -e "$jetbrainsConfig" && -n "$jetbrainsMono" ]]; then
    currentJetbrainsMonoFontName="$(xmllint --xpath '//application/component/option[@name="FONT_FAMILY"][@value]/@value' "$jetbrainsConfig" 2> /dev/null | awk -F'[="]' '!/>/{print $(NF-1)}')"
    currentJetbrainsMonoFontSize="$(xmllint --xpath '//application/component/option[@name="FONT_SIZE"][@value]/@value' "$jetbrainsConfig" 2> /dev/null | awk -F'[="]' '!/>/{print $(NF-1)}')"
    currentJetbrainsMonoFontSize2d="$(xmllint --xpath '//application/component/option[@name="FONT_SIZE_2D"][@value]/@value' "$jetbrainsConfig" 2> /dev/null | awk -F'[="]' '!/>/{print $(NF-1)}')"
    wantedJetbrainsMonoFontName="$currentJetbrainsMonoFontName"
    wantedJetbrainsMonoFontSize="$jetbrainsMono"
    wantedJetbrainsMonoFontSize2d="$jetbrainsMono.0"

    # Update JetBrains config if different.
    if [[ "$currentJetbrainsMonoFontSize" && "$currentJetbrainsMonoFontSize" != "$wantedJetbrainsMonoFontSize" ]]; then
      log.info "Setting $(echo "$jetbrainsConfig" | cut -d/ -f6) monospace font to: \"$currentJetbrainsMonoFontName $wantedJetbrainsMonoFontSize\""
      currentJetbrainsMonoFontNameString="name=\"FONT_FAMILY\" value=\"$currentJetbrainsMonoFontName\""
      wantedJetbrainsMonoFontNameString="name=\"FONT_FAMILY\" value=\"$wantedJetbrainsMonoFontName\""
      currentJetbrainsMonoFontSizeString="name=\"FONT_SIZE\" value=\"$currentJetbrainsMonoFontSize\""
      wantedJetbrainsMonoFontSizeString="name=\"FONT_SIZE\" value=\"$wantedJetbrainsMonoFontSize\""
      currentJetbrainsMonoFontSize2dString="name=\"FONT_SIZE_2D\" value=\"$currentJetbrainsMonoFontSize2d\""
      wantedJetbrainsMonoFontSize2dString="name=\"FONT_SIZE_2D\" value=\"$wantedJetbrainsMonoFontSize2d\""
      sed -i "s|$currentJetbrainsMonoFontNameString|$wantedJetbrainsMonoFontNameString|g" "$jetbrainsConfig"
      sed -i "s|$currentJetbrainsMonoFontSizeString|$wantedJetbrainsMonoFontSizeString|g" "$jetbrainsConfig"
      sed -i "s|$currentJetbrainsMonoFontSize2dString|$wantedJetbrainsMonoFontSize2dString|g" "$jetbrainsConfig"
    fi
  fi
  done

  # Current and wanted Vim settings.
  vimConfig="$HOME/.vimrc"
  if [[ -e "$vimConfig" && -n "$vimMono" ]]; then
    currentVimMonoFontName="$(grep -A1 "if has('gui_gtk3')" "$vimConfig" | tail -n1 | cut -d= -f2 | sed -e 's|\\||g' -e 's|[0-9\.]||g' -e 's|[[:space:]]*$||g')"
    currentVimMonoFontSize="$(grep -A1 "if has('gui_gtk3')" "$vimConfig" | tail -n1 | cut -d= -f2 | awk -F '\\\\ ' '{print $NF}')"
    wantedVimMonoFontSize="$vimMono"

    # Update Vim config if different.
    if [[ "$currentVimMonoFontSize" != "$wantedVimMonoFontSize" ]]; then
      log.info "Setting Vim monospace font to: \"$currentVimMonoFontName $wantedVimMonoFontSize\""
      currentVimMonoFontString="set guifont=$(echo "$currentVimMonoFontName $currentVimMonoFontSize" | sed 's| |\\\\ |g')"
      wantedVimMonoFontString="set guifont=$(echo "$currentVimMonoFontName $wantedVimMonoFontSize" | sed 's| |\\\\ |g')"
      sed -i "s|$currentVimMonoFontString|$wantedVimMonoFontString|g" "$vimConfig"
    fi
  fi

  # X11 config file.
  x11Config="$HOME/.Xresources"

  # Current and wanted X11 dpi.
  if [[ -e "$x11Config" && -n "$x11Dpi" ]]; then
    currentX11DpiValue="$(grep 'Xft.dpi:' "$x11Config" | awk '{ print $2 }')"
    wantedX11DpiValue="$x11Dpi"

    if [[ "$currentX11DpiValue" != "$wantedX11DpiValue" ]]; then
      log.info "Setting X11 dpi value to: \"$wantedX11DpiValue\""
      currentX11DpiString="Xft.dpi: $currentX11DpiValue"
      wantedX11DpiString="Xft.dpi: $wantedX11DpiValue"
      sed -i "s|$currentX11DpiString|$wantedX11DpiString|g" "$x11Config"
    fi
  fi

  # Current and wanted X11 default font.
  if [[ -e "$x11Config" && -n "$x11Sans" ]]; then
    # assuming *font: string matching something like
    # -*-helvetica-bold-r-*-*-17-*-*-*-*-*-iso8859-15
    # The '17' above is the font size (eighth position).
    currentX11SansFontSize="$(grep '^\*font:' "$x11Config" | cut -d- -f8)"
    wantedX11SansFontSize="$x11Sans"

    if [[ "$currentX11SansFontSize" != "$wantedX11SansFontSize" ]]; then
      log.info "Setting X11 default font size to: \"$wantedX11SansFontSize\""
      currentX11SansFontString="$(grep '^\*font:' "$x11Config")"
      wantedX11SansFontString="$(echo "$currentX11SansFontString" | sed "s|-$currentX11SansFontSize-|-$wantedX11SansFontSize-|g")"
      sed -i "s|$currentX11SansFontString|$wantedX11SansFontString|g" "$x11Config"
    fi
  fi

  # Current and wanted X11 uxterm and xterm font sizes.
  if [[ -e "$x11Config" && -n "$x11Mono" ]]; then
    currentX11UxtermFontSize="$(grep '^UXTerm\*faceSize' "$x11Config" | awk '{ print $2 }')"
    wantedX11UxtermFontSize="$x11Mono"
    currentX11XtermFontSize="$(grep '^XTerm\*faceSize' "$x11Config" | awk '{ print $2 }')"
    wantedX11XtermFontSize="$x11Mono"

    if [[ "$currentX11UxtermFontSize" != "$wantedX11UxtermFontSize" ]]; then
      log.info "Setting X11 uxterm font size to: \"$wantedX11UxtermFontSize\""
      currentX11UxtermFontString="UXTerm*faceSize: $currentX11UxtermFontSize"
      wantedX11UxtermFontString="UXTerm*faceSize: $wantedX11UxtermFontSize"
      sed -i "s|$currentX11UxtermFontString|$wantedX11UxtermFontString|g" "$x11Config"
    fi

    if [[ "$currentX11XtermFontSize" != "$wantedX11XtermFontSize" ]]; then
      log.info "Setting X11 xterm font size to: \"$wantedX11XtermFontSize\""
      currentX11XtermFontString="XTerm*faceSize: $currentX11XtermFontSize"
      wantedX11XtermFontString="XTerm*faceSize: $wantedX11XtermFontSize"
      sed -i "s|$currentX11XtermFontString|$wantedX11XtermFontString|g" "$x11Config"
    fi
  fi

  # Current and wanted X11 cursor size.
  if [[ -e "$x11Config" && -n "$x11Cursor" ]]; then
    currentX11CursorSize="$(grep 'Xcursor.size:' "$x11Config" | awk '{ print $2 }')"
    wantedX11CursorSize="$x11Cursor"

    if [[ "$currentX11CursorSize" != "$wantedX11CursorSize" ]]; then
      log.info "Setting X11 cursor size to: \"$wantedX11CursorSize\""
      currentX11CursorString="Xcursor.size: $currentX11CursorSize"
      wantedX11CursorString="Xcursor.size: $wantedX11CursorSize"
      sed -i "s|$currentX11CursorString|$wantedX11CursorString|g" "$x11Config"
    fi
  fi

  # Current and wanted Alacritty font size.
  alacrittyConfig="$HOME/.config/alacritty/alacritty.toml"
  if [[ -e "$alacrittyConfig" && -n "$alacrittyMono" ]]; then
    currentAlacrittyMonoFontSize="$(grep '^size = ' "$alacrittyConfig" | awk '{ print $3 }')"
    wantedAlacrittyMonoFontSize="$alacrittyMono"

    if [[ "$currentAlacrittyMonoFontSize" != "$wantedAlacrittyMonoFontSize" ]]; then
      log.info "Setting Alacritty font size to: \"$wantedAlacrittyMonoFontSize\""
      currentAlacrittyMonoFontString="$(echo "size = $currentAlacrittyMonoFontSize" | sed 's|\.|\\\.|g')"
      wantedAlacrittyMonoFontString="$(echo "size = $wantedAlacrittyMonoFontSize" | sed 's|\.|\\\.|g')"
      sed -i "s|$currentAlacrittyMonoFontString|$wantedAlacrittyMonoFontString|g" "$alacrittyConfig"
    fi
  fi

  # Write a timer file so we don't keep doing this for every shell invocation.
  echo "user-scaling.sh ran at $(date)" > /tmp/user-scaling.timer
fi

# Unset temporary variables.
unset FONT_SIZE_PREFERENCES_FILE codeConfig emacsHostIdentifier emacsConfig jetbrainsConfigs jetbrainsConfig vimConfig codeMono emacsMono emacsSans gnomeMono gnomeSans gnomeSerif jetbrainsMono vimMono currentCodeEditorFontName currentCodeEditorFontSize currentCodeTerminalFontName currentCodeTerminalFontSize currentEmacsMonospaceFontName currentEmacsMonospaceFontSize currentEmacsVariablewidthFontName currentEmacsVariablewidthFontSize currentGnomeDocumentFontName currentGnomeDocumentFontSize currentGnomeInterfaceFontName currentGnomeInterfaceFontSize currentGnomeMonospaceFontName currentGnomeMonospaceFontSize currentGnomeThemeFontName currentGnomeThemeFontSize currentGnomeTitleFontName currentGnomeTitleFontSize currentJetbrainsMonoFontName currentJetbrainsMonoFontSize currentJetbrainsMonoFontSize2d currentVimMonoFontName currentVimMonoFontSize wantedCodeEditorFontSize wantedCodeTerminalFontSize wantedEmacsMonospaceFontSize wantedEmacsVariablewidthFontSize wantedGnomeDocumentFontSize wantedGnomeInterfaceFontSize wantedGnomeMonospaceFontSize wantedGnomeThemeFontSize wantedGnomeTitleFontSize wantedJetbrainsMonoFontName wantedJetbrainsMonoFontSize wantedJetbrainsMonoFontSize2d wantedVimMonoFontSize currentQt5MonoFontName currentQt5MonoFontSize currentQt5SansFontName currentQt5SansFontSize currentQt6MonoFontName currentQt6MonoFontSize currentQt6SansFontName currentQt6SansFontSize wantedQt5MonoFontName wantedQt5MonoFontSize wantedQt5SansFontName wantedQt5SansFontSize wantedQt6MonoFontName wantedQt6MonoFontSize wantedQt6SansFontName wantedQt6SansFontSize emacsHostIdentifierInConfigMonospace emacsHostIdentifierInConfigVariablewidth qt5Config qt5Mono qt5Sans qt6Config qt6Mono qt6Sans themeConfig wantedAlacrittyMonoFontSize wantedX11CursorSize wantedX11SansFontSize wantedX11UxtermFontSize wantedX11XtermFontSize x11Config x11Cursor x11Mono x11Sans alacrittyConfig alacrittyMono currentAlacrittyMonoFontSize currentX11CursorSize currentX11SansFontSize currentX11UxtermFontSize currentX11XtermFontSize
