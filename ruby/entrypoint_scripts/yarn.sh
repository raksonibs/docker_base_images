#!/bin/bash
echo "Verifying node modules are up-to-date with yarn"
yarn check || yarn install --check-files --mutex file
