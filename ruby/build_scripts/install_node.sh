#!/bin/bash
set -ex

NODE_VERSION=${1:-8.11.3}

# gpg keys listed at https://github.com/nodejs/node#release-team
for key in \
  114F43EE0176B71C7BC219DD50A3051F888C628D \
  56730D5401028683275BD23C23EFEFE93C4CFFFE \
  71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
  77984A986EBC2AA786BC0F66B01FBB92821C587A \
  7937DFD2AB06298B2293C3187D33FF9D0246406D \
  93C7E9E91B49E432C2F75674B0A78B0A6C481CF6 \
  94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
  9554F04D7259F04124DE6B476D5A82AC7E37093B \
  B9AE9905FFD7803F25714661B63B535A4C206CA9 \
  C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  FD3A5288F042B6850C66B31F09FE44734EB7990E \
; do
    gpg --keyserver pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" ; \
done

curl -SLO "https://nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz"

curl -SLO "https://nodejs.org/download/release/v$NODE_VERSION/SHASUMS256.txt.asc"
gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc
grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c -

tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1
rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt
