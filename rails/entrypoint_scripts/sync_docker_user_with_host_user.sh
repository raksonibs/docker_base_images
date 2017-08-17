#!/bin/sh
set -e

# we find the host uid/gid by assuming the app directory belongs to the host
HOST_UID=$(stat -c %u /home/docker/app)
HOST_GID=$(stat -c %g /home/docker/app)

# If the docker user doesn't share the same uid, change it so that it does
if [ ! "${HOST_UID}" = "$(id -u docker)" ]; then
  usermod -u $HOST_UID docker
  groupmod -g $HOST_GID docker

  # also update the file uid/gid for files in the docker home directory
  # skip the mounted "app" dir because we don't want any changes to mounted file ownership
  for file in /home/docker/*; do
    if [ $file != "/home/docker/app" ]; then
      chown -R docker:docker $file
    fi
  done
fi
