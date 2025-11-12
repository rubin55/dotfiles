#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return

# For rabbitmq (prepending to path to avoid using wrapper scripts in /usr/bin).
path.which rabbitmqctl /usr/lib/rabbitmq/bin || return
export PATH=/usr/lib/rabbitmq/bin:$PATH

# For rabtap (default connection settings to a local rabbitmq node/cluster).
path.which rabtap || return
export RABTAP_APIURI=http://guest:guest@localhost:15672/api
export RABTAP_AMQPURI=amqp://guest:guest@localhost:5672/
