#!/bin/bash

# default of 60 iterations = 600 seconds = 10 minutes
ITERATIONS=${WAIT_FOR_BUNDLE:-60}
BUNDLE_READY=false

bundle config --delete without

for i in $(seq 1 $ITERATIONS); do
  if bundle check > /dev/null; then
    BUNDLE_READY=true
    break
  else
    echo "Waiting for bundle install..."
    sleep 10
  fi
done

if [ $BUNDLE_READY = "false" ]; then
  echo "Bundle install still not complete, exiting"
  exit 1
fi
