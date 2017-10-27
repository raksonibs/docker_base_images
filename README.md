The Dockerfiles in this repo are built and published publicly at https://hub.docker.com/r/voxmedia

## Docker Test Kitchen Images

To update it:

- Built it locally with a `docker build .` and note the resulting ID.
- Run `docker tag ID voxmedia/docker_base_images:docker_test_kitchen-VERSION`
- `docker push voxmedia/docker_base_images:docker_test_kitchen-VERSION`

## Ruby Images

The ruby base images include docker-ssh-exec and some standard entrypoint scripts. An example of an entrypoint script
using this image would look like this:

    #!/bin/bash
    set -e
    docker-ssh-exec /opt/entrypoint/bundle.sh $1
    /opt/entrypoint/cleanup_pids.sh
    /opt/entrypoint/service_health_checks/mysql.sh
    exec docker-ssh-exec "$@"

Note that this example includes `docker-ssh-exec` directly in the exec command, to make keys available to all commands without having to remember which commands require it and reference docker-ssh-exec manually.

### Updating the images

- Make your changes
- Bump the version in `VERSION`
- Run `ruby/build.sh`

### Ruby images changelog

#### Version ruby:2.x-1.0.0

* Now using semantic versioning for the base image
* Added entrypoint script `use_dns_server` script (can't use the docker-compose "dns" option because that only accepts static ip addresses)

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
