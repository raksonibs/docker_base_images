#!/bin/bash

## each separate version number must be less than 3 digit wide !
function version { echo "$@" | awk -F. '{ printf("%03d%03d%03d\n", $1,$2,$3); }'; }

# get the hosted VERSION
LATEST_VERSION=`curl --silent nginx/ruby/VERSION`

# get the current base image version -- $IMAGE_VERSION -- is added to the base image on build

if [ "$(version "$LATEST_VERSION")" -gt "$(version "$IMAGE_VERSION")" ] ; then
  echo "There is a newer version of the ruby docker base image available. Please update your docker image to use the latest version." ;
  echo
  echo "################################################################################"
  # now output the CHANGELOG.md
  # https://stackoverflow.com/a/10929511/1571834
  while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ $line = *"$IMAGE_VERSION"* ]]; then
      break;
    fi
    echo $line
  done < <(curl --silent nginx/ruby/CHANGELOG.md)
  echo "..."
  echo "################################################################################"

  echo
  echo "To see the full CHANGELOG, please visit https://github.com/voxmedia/docker_base_images/ruby/CHANGELOG.md"
fi
