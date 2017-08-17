#!/bin/sh
set -e

# we find the host uid/gid by assuming the app directory belongs to the host
HOST_UID=$(stat -c %u /home/docker/app)
HOST_GID=$(stat -c %g /home/docker/app)

# If the docker user doesn't share the same uid, change it so that it does
if [ ! "${HOST_UID}" = "$(id -u docker)" ]; then
  usermod -u $HOST_UID docker
  groupmod -g $HOST_GID docker
  chown -R docker:docker /home/docker
fi
