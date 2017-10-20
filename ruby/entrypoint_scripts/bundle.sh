#!/bin/bash
if [ "$1" != "bundle" ]; then
  echo "Checking bundle"
  bundle check || bundle install
fi
