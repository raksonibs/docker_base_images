#!/bin/bash

set -euxo pipefail

DEV_REQUIREMENTS_FILE=${1:-dev_requirements.txt}

if [ "$PIP_ENV" = "development" ]; then
  pip install -r $DEV_REQUIREMENTS_FILE
fi
