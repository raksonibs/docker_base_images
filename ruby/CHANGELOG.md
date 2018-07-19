### Ruby images changelog

#### Version ruby:2.x-3.x.x

* Fixed typo in `wait_for_node_install.sh`

#### Version ruby:2.x-3.0.3

* Deprecates Ruby 2.2
* Updates node_install script to use multiple pgp key servers
* Updates node_install script to use current LTS as the default version (8.11.3)
* Installs some standard tools: vim, less, unzip, ifconfig (via net-tools), ping (via iputils-ping)

#### Version ruby:2.x-3.0.2

* Adds `libcurl4-openssl-dev` to support ffi gem.

#### Version ruby:2.x-3.0.1

* Add a few missing apt packages

#### Version ruby:2.x-3.0.0

* The base image now derives from a generic ubuntu image. The dockerhub ruby image that it used to derive from does some opinionated bundler config that conflicts with our own.
* The bundler config (now entirely under our control) has been updated according our desired behavior.

#### Version ruby:2.x-2.5.3

* Fixes the mutex in the entry script `yarn.sh` to use the current working directory to prevent collisions between multiple `yarn install` runs.

#### Version ruby:2.x-2.5.2

* Adds a mutex to the entry script `yarn.sh` to prevent cache collisions between multiple `yarn install` runs.

#### Version ruby:2.x-2.5.1

* Removes gemnasium
* Moves from dockerhub to docker.voxops.net

#### Version ruby:2.x-2.5.0

* Adds `install_go.sh` build script and the `build_go.sh` entrypoint script

#### Version ruby:2.x-2.4.1

* Adds `-q` to the pip install script to quiet it -- it was being way too verbose.

#### Version ruby:2.x-2.4.0

* Adds `install_python.sh` build script and the `pip.sh` entrypoint script.

#### Version ruby:2.x-2.3.0

* Adds the `-y` flag to the `install_yarn.sh` script to prevent prompts from interrupting the installation.

#### Version ruby:2.x-2.2.0

* Updates `bundle.sh` and `wait_for_bundle_install.sh` entrypoint scripts to first remove any cached `without` config, to make sure they both check/install all depednencies.
* Changes the elasticsearch healthcheck backoff strategy. Previous strategy was 10 iterations, with a progressively increasing wait per iteration but capped at 5 seconds. New strategy is 15 iterations with no cap on wait. Turns out the previous strategy was not waiting long enough in certain contexts.
* Updates default node version (when unspecified) to a much newer version.
* Adds an `install_yarn.sh` entrypoint script (and adds `apt-transport-https` to the base Dockerfile, to allow https apt sources -- needed for yarn, but generally useful to have anyway).

#### Version ruby:2.x-2.1.0

* Updated base images to include newest point release, Ruby 2.5

#### Version ruby:2.x-2.0.0

* Create `ruby/entrypoint_scripts/dispatcher.sh` to standardize entrypoint script execution in apps.
* Create NPM and Yarn entrypoint scripts (analogous to the pre-existing bundle.sh entrypoint script) that will ensure node packages are up to date.
* Add Bundler and Node entrypoint scripts to ensure all package installations have completed before continuing.
* Add healthcheck entrypoint scripts for Elasticsearch and Redis to ensure that the services are up and running before continuing.
* Update the following entrypoint scripts to use environment variables instead of arguments. This is a **breaking change** for apps that pass in custom values.
  * `use_dns_server.sh` (now uses $DNS_HOST)
  * `service_health_checks/mysql.sh` (now uses $WAIT_FOR_MYSQL)
* Pin Bundler gem to latest version (1.16.0)

#### Version ruby:2.x-1.1.1

* Update GPG keys for node install

#### Version ruby:2.x-1.1.0

* Sets it up so that if the dns server name passed in doesn't resolve, then make it a no-op

#### Version ruby:2.x-1.0.0

* Now using semantic versioning for the base image
* Added entrypoint script `use_dns_server.sh` (can't use the docker-compose "dns" option because that only accepts static ip addresses)

#### Version ruby:2.x-0.10

* Set it up to only do the bundle check/install step if not directly running a bundle command already

#### Version ruby:2.x-0.9

* Fix some syntax errors accidentally introduced in 0.8

#### Version ruby:2.x-0.8

* Bundle install actually doesn't need docker-ssh-exec, it needs to be outside.

#### Version ruby:2.x-0.7

* Bundle install needs docker-ssh-exec

#### Version ruby:2.x-0.6

* Switch to linear backoff with a maximum of 5 seconds

#### Version ruby:2.x-0.5

* The image is now `ruby` instead of `docker_base_images`
* Added `#!/bin/bash` to all entrypoint scripts

#### Version docker_base_images:ruby_2.3-0.4

* Adds bundle entrypoint script
* Adjusts MySQL health-check to use exponential backoff, and allow setting iteration count via parameter

#### Version docker_base_images:ruby_2.3-0.3

* Updated ruby to 2.2.8, 2.3.5, and 2.4.2 to address CVEs
* Tags are now  `docker_base_images:ruby_2.2-0.3` and corresponding for ruby 2.3 and 2.4
* Moved all the functionality of the `rails` image into the base `ruby` images

#### Version docker_base_images:rails_0.3

* Adds `install_phantomjs.sh` build script.

#### Version docker_base_images:rails_0.2

* Adds a `build_scripts` directory with an `install_node.sh` script. It's not run automatically--child images can choose to run if it necessary.

#### Version docker_base_images:rails_0.1

* Initial rails base image
* Sets locale C.UTF-8, adds docker-ssh-exec, adds entrypoint helper scripts
* Entrypoint script for cleaning stale pids that rails leaves around
* Entrypoint script for mysql service health check
