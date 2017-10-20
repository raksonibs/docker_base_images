#!/bin/bash
if [ "$1" != "bundle" ] && [ "$2" != "update" ]; then
  echo "Checking bundle"
  bundle check || bundle install
fi
