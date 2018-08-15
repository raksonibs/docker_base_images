#!/bin/bash

## each separate version number must be less than 3 digit wide !
function version { echo "$@" | awk -F. '{ printf("%03d%03d%03d\n", $1,$2,$3); }'; }

# get the VERSION and CHANGELOG.md file from the docker_base_images repo
(cd /tmp && \
docker-ssh-exec git clone --quiet --depth=1 --bare git@github.com:voxmedia/docker_base_images.git TEMPDIRNAME123 && \
mkdir -p ruby && \
docker-ssh-exec git --bare --git-dir=TEMPDIRNAME123 --work-tree=./ checkout --quiet -f HEAD -- ruby/VERSION ruby/CHANGELOG.md && \
rm -rf TEMPDIRNAME123) &> /tmp/base_image_check.log

if [ $? -gt 0 ] ; then
  # error getting version...
  echo "⚠️   Unable to retrieve the current base image information from the github repo.  ⚠️"
  echo "⚠️   Are you connected to the internet?                                           ⚠️"
else
  LATEST_VERSION=`cat /tmp/ruby/VERSION`
  # get the current base image version -- $IMAGE_VERSION -- is added to the base image on build
  if [ "$(version "$LATEST_VERSION")" -gt "$(version "$IMAGE_VERSION")" ] ; then
    echo "🌩  There is a newer version of the ruby docker base image available.  🌩"
    echo "🌩  Please update your docker image to use the latest version.         🌩"
    echo
    echo "################################################################################"
    # now output the CHANGELOG.md
    # https://stackoverflow.com/a/10929511/1571834
    while IFS='' read -r line || [[ -n "$line" ]]; do
      if [[ $line = *"$IMAGE_VERSION"* ]]; then
        break;
      fi
      echo "$line"
    done < <(cat /tmp/ruby/CHANGELOG.md)
    echo "..."
    echo "################################################################################"
    echo
    echo "To see the full CHANGELOG, please visit https://github.com/voxmedia/docker_base_images/ruby/CHANGELOG.md"
  else
    echo "The current base image ($IMAGE_VERSION) is up-to-date! 👍"
  fi
fi
