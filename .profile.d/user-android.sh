#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p log.info path.append || return

# Inherit or set ANDROID_HOME.
ANDROID_HOME="${ANDROID_HOME:-/opt/android-sdk}"

# If ANDROID_HOME exists, do a few things extra.
if [[ -d "$ANDROID_HOME" ]]; then
  ANDROID_NDK_HOME="${ANDROID_NDK_HOME:-$(find "$ANDROID_HOME/ndk" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sort -Vr | head -n1)}"
  ANDROID_NDK_TARGETS="${ANDROID_NDK_TARGETS:-x86_64}"
  export ANDROID_HOME ANDROID_NDK_HOME ANDROID_NDK_TARGETS
  export PATH=$(path.append "$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_NDK_HOME" "$PATH")
else
  unset ANDROID_HOME ANDROID_NDK_HOME ANDROID_NDK_TARGETS
fi
