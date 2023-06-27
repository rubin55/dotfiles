#!/bin/bash

if path.which vbccm68k; then
  export VBCC="$(which vbccm68k | sed 's#/bin/vbccm68k##g')"
fi
