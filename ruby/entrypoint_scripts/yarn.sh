#!/bin/bash
echo "Verifying node modules are up-to-date with yarn"
if [[ $((`ls ./node_modules|wc -l`)) == 0 ]] || ! yarn check --silent ; then
  yarn install --silent --check-files --mutex file
fi
