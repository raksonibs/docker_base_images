#!/bin/bash

set -euxo pipefail

DEV_REQUIREMENTS_FILE=${DEV_REQUIREMENTS_FILE:-dev_requirements.txt}

if [ "$PIP_ENV" = "development" ]; then
  pip install -q -r $DEV_REQUIREMENTS_FILE
fi
