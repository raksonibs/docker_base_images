#!/bin/bash
echo "Verifying node modules are up-to-date with yarn"
yarn check 2>/dev/null || yarn install --check-files --mutex file
