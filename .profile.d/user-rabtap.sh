#!/bin/bash

# Check if functions are loaded and if required executables are available.
type -p path.which || return
path.which rabtap || return

export RABTAP_APIURI=http://guest:guest@localhost:15672/api
export RABTAP_AMQPURI=amqp://guest:guest@localhost:5672/
