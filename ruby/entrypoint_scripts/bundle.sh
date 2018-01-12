#!/bin/bash
if [ "$1" != "bundle" ]; then
  echo "Checking bundle"
  bundle config --delete without
  bundle check || bundle install
fi
