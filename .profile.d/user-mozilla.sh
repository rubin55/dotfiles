#!/bin/bash

if path.which firefox && [ "$XDG_SESSION_TYPE" == "wayland" ]; then
  export MOZ_ENABLE_WAYLAND=1
fi
