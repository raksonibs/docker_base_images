#!/bin/sh
#
# This is a standard docker entrypoint for rails apps.
#
# * Removes stale server pids
# * Waits for mysql alive before proceeding
# * Runs the passed command through `docker-ssh-exec` and `bundle exec`
#
# To use it, set the entrypoint (in the Dockerfile or docker-compose.yml) to:
#
# /usr/local/bin/docker_entrypoint.sh
#

set -e

# clean up any stale pidfiles left over from previous runs
rm -f tmp/pids/*.pid

# if MYSQL_HOST is present, make sure mysql is alve before proceeding
if [ ! -z "${MYSQL_HOST}" ]; then
  MYSQL_UP=false
  for i in $(seq 1 10); do
    if mysqladmin ping -h ${MYSQL_HOST} --silent > /dev/null; then
      MYSQL_UP=true
      break
    else
      sleep 1
    fi
  done

  if [ $MYSQL_UP = "false" ]; then
    echo "Unable to connect to database. Please make sure your ${MYSQL_HOST} container is running and healthy."
    exit 1
  fi
fi

# pass through to the original cmd
# include `docker-ssh-exec` and `bundle exec` for convenience
exec docker-ssh-exec bundle exec "$@"
