#!/bin/bash

# Set docker host to specific vm if up.
#ping -c1 -q -t1 -W100 10.10.11.3 > /dev/null 2>&1
#if [ $? == 0 ]; then
#    echo "Notice: host 10.10.11.3 is up, will use as Docker host.."
#    export DOCKER_HOST=tcp://10.10.11.3:2375
#fi
