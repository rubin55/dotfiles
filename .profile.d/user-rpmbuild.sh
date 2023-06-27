#!/bin/bash

path.which rpmbuild
if [ $? == 0 ]; then
  export RPM_BUILD_NCPUS=$(nproc)
fi
