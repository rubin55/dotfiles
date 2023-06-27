#!/bin/bash

if path.which rabtap; then
  export RABTAP_APIURI=http://guest:guest@localhost:15672/api
  export RABTAP_AMQPURI=amqp://guest:guest@localhost:5672/
fi
