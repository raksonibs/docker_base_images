The Dockerfiles in this repo are built and published publicly at https://hub.docker.com/r/voxmedia/docker_base_images

What images are built is controlled by the automated build settings on Docker Hub. Right now, each Dockerfile is manually added
and built based on tags that match it's name. For example, `ruby/2.2/Dockerfile` is built when a git tag
matching `ruby/2.2:0.1` is pushed, where 0.1 is the version we want to publish. Afterwords, application specific
Dockerfiles can reference the publically available image at `voxmediad/docker_base_images:ruby_2.2-0.1`.
