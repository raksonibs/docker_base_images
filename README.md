The Dockerfiles in this repo are built and published publicly at https://hub.docker.com/r/voxmedia/docker_base_images

What images are built is controlled by the automated build settings on Docker Hub. Right now, each Dockerfile is manually added
and built based on tags that match it's name. For example, `ruby/2.2/Dockerfile` is built when a git tag
matching `ruby/2.2-0.1` is pushed, where 0.1 is the version we want to publish. Afterwords, application specific
Dockerfiles can reference the publically available image at `voxmediad/docker_base_images:ruby_2.2-0.1`.

### The rails base image

The rails base image includes docker-ssh-exec and some standard entrypoint scripts. An example of an entrypoint script
using this image would look like this:

    #!/bin/sh
    set -e
    /opt/entrypoint/cleanup_pids.sh
    /opt/entrypoint/service_health_checks/mysql.sh
    exec docker-ssh-exec bundle exec "$@"

Note that this example includes `docker-ssh-exec` directly in the exec command, to make keys available to all commands
without having to remember which commands require it and reference docker-ssh-exec manually.

### CAVEAT

For some reason, Docker hub doesn't build the docker_test_kitchen image - it errors out wheneve it tries.
To update it:

- Built it locally with a `docker build .` and note the resulting ID.
- Run `docker tag ID voxmedia/docker_base_images:docker_test_kitchen-VERSION`
- `docker push voxmedia/docker_base_images` (this will _maybe_ overrite existing tags but I really hope not)
