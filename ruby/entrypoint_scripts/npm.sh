#!/bin/bash
if [ "$1" != "npm" ]; then
  echo "Updating node modules"
  npm update
fi
