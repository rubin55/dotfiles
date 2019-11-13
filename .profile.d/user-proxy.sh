#!/bin/bash

# Set up proxy when connected to a certain wireless network.
#SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')
#if [ "$SSID" == "Corporate" ]; then
#    echo "Notice: connected to Corporate network, enabling proxy settings.."
#    proxy-mac.sh on > ~/.proxy.env
#else
#    proxy-mac.sh off > ~/.proxy.env
#fi
#source ~/.proxy.env

# Set up proxy when a certain SSH command is detected as running.
#CHECK=$(ps ax | grep 'ssh -4 -L 10.10.10.1:49151:194.109.6.13:8080 -D 10.10.10.1:1080 -p 443 rubin@shell.xs4all.nl' | grep -v grep)
#if [ ! -z "$CHECK" ]; then
#    echo "Notice: SSH with proxy tunneling detected, enabling proxy settings.."
#    http_proxy=http://10.10.10.1:49151
#    https_proxy=$http_proxy
#    HTTP_PROXY=$http_proxy
#    HTTPS_PROXY=$http_proxy
#    export http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
#fi
