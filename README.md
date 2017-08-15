The Dockerfiles in this repo are built and published publicly at https://hub.docker.com/r/voxmedia/docker_base_images

What images are built is controlled by the automated build settings on Docker Hub. Right now, each Dockerfile is manually added
and built based on tags that match it's name. For example, `ruby/2.2/Dockerfile` is built when a git tag
matching `ruby/2.2-0.1` is pushed, where 0.1 is the version we want to publish. Afterwords, application specific
Dockerfiles can reference the publically available image at `voxmediad/docker_base_images:ruby_2.2-0.1`.

## Docker test kitchen caveat

For some reason, Docker hub doesn't build the docker_test_kitchen image - it errors out wheneve it tries.
To update it:

- Built it locally with a `docker build .` and note the resulting ID.
- Run `docker tag ID voxmedia/docker_base_images:docker_test_kitchen-VERSION`
- `docker push voxmedia/docker_base_images` (this will _maybe_ overrite existing tags but I really hope not)

## The rails base image

The rails base image includes docker-ssh-exec and some standard entrypoint scripts. An example of an entrypoint script
using this image would look like this:

    #!/bin/sh
    set -e
    /opt/entrypoint/cleanup_pids.sh
    /opt/entrypoint/service_health_checks/mysql.sh
    /opt/entrypoint/exec_as_host_user.sh "$@"

### Rails base image changelog

#### Version 0.2

* Adds exec_as_host_user.sh to create a non-root user with same uid/gid as host, for proper file system permissions when files are written to a volume from a container
* Installs "sudo", a necessary piece of that new entrypoint script
* Adds "/app/bin" to the path for access to binstubs

#### Version 0.1

* Initial rails base image
* Sets locale C.UTF-8, adds docker-ssh-exec, adds entrypoint helper scripts
* Entrypoint script for cleaning stale pids that rails leaves around
* Entrypoint script for mysql service health check
