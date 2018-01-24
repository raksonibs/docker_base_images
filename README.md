The Dockerfiles in this repo are built and published publicly at https://hub.docker.com/r/voxmedia

## Docker Test Kitchen Images

To update it:

- Build it locally with a `docker build .` and note the resulting ID.
- Run `docker tag ID voxmedia/docker_base_images:docker_test_kitchen-VERSION`
- `docker push voxmedia/docker_base_images:docker_test_kitchen-VERSION`

## Ruby Images

The ruby base images include `docker-ssh-exec` and some standard entrypoint scripts. An example of an entrypoint script
using this image would look like this:

    #!/bin/bash
    set -e
    docker-ssh-exec /opt/entrypoint/bundle.sh $1
    /opt/entrypoint/cleanup_pids.sh
    /opt/entrypoint/service_health_checks/mysql.sh
    exec docker-ssh-exec "$@"

Note that this example includes `docker-ssh-exec` directly in the exec command, to make keys available to all commands without having to remember which commands require it and reference `docker-ssh-exec` manually.

### Testing the images locally

- Make your changes, then run `docker build . --build-arg RUBY_VERSION=2.3 -t base-image-test` to build your image
- Temporarily replace the base image of the app you'd like to test against by editing its Dockerfile to say `FROM base-image-test:latest`

### Updating the images

- Make your changes
- Bump the version in `VERSION`
- Run `ruby/build.sh`

### Ruby images changelog

#### Version ruby:2.x-2.4.0

* Updates `bundle.sh` by adding a check for the `RAILS_ENV` environment variable. If set to `development` or `test` all dependencies will be installed, if not, only the production dependencies will be installed.

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
