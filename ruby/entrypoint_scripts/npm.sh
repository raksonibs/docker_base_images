#!/bin/bash
echo "Updating node modules with npm"
npm ls --no-progress > /dev/null 2>&1 || npm install
