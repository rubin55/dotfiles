#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p env.persist path.which || return
path.which java || return

# Add JAVA_HOME, pointing at the currently active JDK/JRE.
env.persist java JAVA_HOME /usr/lib/jvm/default
