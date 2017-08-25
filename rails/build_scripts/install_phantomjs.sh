#!/bin/bash
set -ex

apt-get update
apt-get install -y libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev libstdc++6 libc6
rm -rf /var/lib/apt/lists/*

curl -SLO https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
tar -xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2
mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
rm -rf phantomjs-2.1.1-linux-x86_64*
