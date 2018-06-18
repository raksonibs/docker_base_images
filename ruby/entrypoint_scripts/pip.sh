#!/bin/bash

DEV_REQUIREMENTS_FILE=${DEV_REQUIREMENTS_FILE:-dev_requirements.txt}

if [ "$PIP_ENV" = "development" ]; then
  echo "Ensuring pip dev requirements are installed"
  pip install -q -r $DEV_REQUIREMENTS_FILE
fi
