#!/bin/bash

# if DATABASE_HOST is present, make sure mysql is alve before proceeding
if [ ! -z "${DATABASE_HOST}" ]; then
  ITERATIONS=${1:-5}
  MYSQL_UP=false
  for i in $(seq 1 $ITERATIONS); do
    if mysqladmin ping -h ${DATABASE_HOST} --silent > /dev/null; then
      MYSQL_UP=true
      break
    else
      WAIT=$(($i**2))
      echo "Waiting $WAIT seconds for MySQL to start..."
      sleep $WAIT
    fi
  done

  if [ $MYSQL_UP = "false" ]; then
    echo "Unable to connect to database. Please make sure your ${DATABASE_HOST} container is running and healthy."
    exit 1
  fi
fi
