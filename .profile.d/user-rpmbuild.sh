#!/bin/bash

RPM_BUILD_EXEC=$(which rpmbuild 2>/dev/null)
if [ ! -z "$RPM_BUILD_EXEC" ]; then
    DETECTED_NCPUS=$(cat /proc/cpuinfo | grep -w '^processor' | wc -l)
    export RPM_BUILD_NCPUS=$(echo $DETECTED_NCPUS / 2 | bc)
fi
