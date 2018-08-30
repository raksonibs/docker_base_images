#!/bin/bash
set -ex

# gpg keys listed at https://github.com/nodejs/node#release-team
# Updated: Aug 29th, 2018
KEYS="94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      B9AE9905FFD7803F25714661B63B535A4C206CA9 \
      77984A986EBC2AA786BC0F66B01FBB92821C587A \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      FD3A5288F042B6850C66B31F09FE44734EB7990E \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D"

SERVERS="pool.sks-keyservers.net \
         keyserver.pgp.com \
         pgp.mit.edu \
         keyserver.ubuntu.com"

function importKeys() {
  for key in $KEYS; do
    for server in $SERVERS; do
      gpg --keyserver "hkp://$server" --recv-keys "$key" && break
    done
  done
  return $?
}

retry=0
maxRetries=5
retryInterval=5
until [ ${retry} -ge ${maxRetries} ]
do
  importKeys && break
  retry=$[${retry}+1]
  echo "Node key import failed. Retrying [${retry}/${maxRetries}] in ${retryInterval}(s) "
  sleep ${retryInterval}
done

if [ ${retry} -ge ${maxRetries} ]; then
  echo "Failed to import keys after ${maxRetries} attempts!"
  exit 1
fi
