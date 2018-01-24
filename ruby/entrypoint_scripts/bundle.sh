#!/bin/bash
if [[ "$1" != "bundle" ]]; then
  echo "Checking bundle"
  if ! [ bundle check ]; then
    [[ $RAILS_ENV == "development" ]] && bundle install || bundle install --without development test
  fi
fi
