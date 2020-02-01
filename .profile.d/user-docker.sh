#!/bin/bash

#DOCKER_HOST="tcp://172.17.1.4:2375"
DOCKER_HOST="tcp://172.17.1.16:2375"
# Set docker host to specific machine if up.
#ping -c1 -q -t1 -W100 10.10.11.3 > /dev/null 2>&1
ping -c 1 -W 1 $(echo $DOCKER_HOST | cut -d '/' -f 3 | cut -d ':' -f 1) > /dev/null 2>&1
if [ $? == 0 ]; then
    echo "Notice: Docker remote host is up, setting DOCKER_HOST=$DOCKER_HOST"
    export DOCKER_HOST
fi
