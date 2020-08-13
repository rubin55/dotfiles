#!/bin/bash

if [ "$(uname -s)" == "Darwin" ]; then
    export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/System/Library/Frameworks/Python.framework/Versions/2.7/lib/pkgconfig:/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/lib/pkgconfig:$HOME/Applications/GnuPG/gnupg22/lib/pkgconfig:$HOME/Applications/GnuTLS/gnutls36/lib/pkgconfig:$HOME/Applications/ICU/icu67/lib/pkgconfig:$HOME/Applications/ImageMagick/im7/lib/pkgconfig:$HOME/Applications/JPEG/jpeg9d/lib/pkgconfig:$HOME/Applications/Nmap/nmap76/lib/pkgconfig:$HOME/Applications/OpenSSL/openssl10/lib/pkgconfig:$HOME/Applications/OpenSSL/openssl11/lib/pkgconfig:$HOME/Applications/Valgrind/vg314/lib/pkgconfig"
fi
