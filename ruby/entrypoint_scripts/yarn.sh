#!/bin/bash
echo "Verifying node modules are up-to-date with yarn"
yarn check --silent || yarn install --silent --check-files --mutex file
