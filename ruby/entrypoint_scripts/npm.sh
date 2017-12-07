#!/bin/bash
if [ "$1" != "npm" ]; then
  echo "Updating node modules"
  npm ls --no-progress > /dev/null 2>&1 || npm install
fi
