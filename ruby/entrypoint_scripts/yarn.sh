#!/bin/bash
if [ "$1" != "yarn" ]; then
  echo "Updating node modules"
  yarn install --check-files
fi
