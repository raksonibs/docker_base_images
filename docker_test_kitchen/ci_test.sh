#!/bin/bash
set -euo pipefail

ssh-keygen -y -f /root/.ssh/id_rsa > /root/.ssh/id_rsa.pub
bundle install --path vendor/bundle

bundle exec foodcritic --epic-fail any ./
bundle exec rubocop
bundle exec kitchen test
