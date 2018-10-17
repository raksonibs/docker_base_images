#!/bin/bash
echo "Verifying node modules are up-to-date with yarn"
if [ ! "$(ls -A ./node_modules)" ] || ! yarn check --silent ; then
  yarn install --silent --check-files --mutex file
fi
