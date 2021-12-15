#!/bin/bash

ansibleCfg="$HOME/Syncthing/Source/ICTU/ansible/ansible.cfg"

platform=$(uname -s | tr '[:upper:]' '[:lower:]')
[[ "$(uname -r)" =~ "icrosoft" ]] && platform=windows

if [[ "$platform" == "windows" && -e "$ansibleCfg" ]]; then
    export ANSIBLE_CONFIG="$ansibleCfg"
fi
