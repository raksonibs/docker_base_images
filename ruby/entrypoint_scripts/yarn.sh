#!/bin/bash
echo "Updating node modules with yarn"
yarn install --check-files --mutex file
