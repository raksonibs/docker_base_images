#!/bin/bash

# default of 60 iterations = 600 seconds = 10 minutes
ITERATIONS=${1:-60}
NODE_READY=false

for i in $(seq 1 $ITERATIONS); do
  if npm ls --no-progress > /dev/null 2>&1; then
    NODE_READY=true
    break
  else
    echo "Waiting for node install..."
    sleep 10
  fi
done

if [ $NODE_READY = "false" ]; then
  echo "Node install still not complete, exiting"
  exit 1
fi
