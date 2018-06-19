#!/bin/bash
set -e

if [ "$1" != "bundle" ]; then
  echo "Checking bundle"
  bundle config --delete without
  bundle check || docker-ssh-exec bundle install
fi

exec "$@"
