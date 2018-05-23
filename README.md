The Dockerfiles in this repo are built and published into our private docker repo at https://docker.voxops.net. All images are tagged `voxmedia/image_name:A.B.C`, where `A.B.C` is the image version. Images should use [semantic versioning](https://semver.org).

## Ruby base image

This is the standard base image used by the majority of our applications, containing common image components. It is geared towards ruby apps, but contains useful functionality for other languages as well. This image contains:

* A collection of build scripts (e.g. `install_node.sh`)
* A collection of entrypoint scripts (e.g. `bundle.sh`)
* The `docker-ssh-exec` client
* Bundler configs
* Mysql command line tools

The build scripts (located at `/opt/build/*` in the image) are intended to be called as needed by individual repos that derive from this base image. For example, if a particular repo requires node, the Dockerfile of that repo can call the included build script via `RUN /opt/build/install_node.sh 8.9.4`.

The entrypoint scripts (located at `/opt/entrypoint/*` in the image) are also included as needed, but not directly. We have a `dispatcher` script that is responsible for calling out to the necessary entrypoints. This system can be used to set up entrypoints for both docker-compose and for containers defined in helm chart container specs.

The dispatcher takes a number of arguments, calling each in turn. The arguments are either a bare word, in which case it looks for an entrypoint file named that at /opt/entrypoint, or they can be fully qualified filenames with paths, for any entrypoint script that is not in that directory (e.g. for a specific repo's custom entrypoint). A `--` argument represents the end of the dispatch scripts and the beginning of the command.

If the entrypoint requires docker-ssh-exec, we can wrap the whole thing by calling `docker-ssh-exec <dispatcher + entrypoints>`, making docker-ssh-exec available throughout.

For example, to set up an entrypoint that includes docker-ssh-exec, updates the bundle and yarn packages, and performs service health checks for mysql and elasticsearch, the entrypoint definition might look like this:

    entrypoint:
      - docker-ssh-exec
      - /opt/entrypoint/dispatcher.sh
      - bundle
      - yarn
      - service_health_checks/mysql
      - service_health_checks/elasticsearch
      - --

### Versioning

A version of this image is released for each supported version of ruby (2.2, 2.3, 2.4, 2.5).

The images are tagged `voxmedia/ruby:2.x-A.B.C`, where `2.x` is the ruby version and `A.B.C` is the image version. The image version uses [semantic versioning](https://semver.org).

And all updates are recorded in a running [CHANGELOG](https://github.com/voxmedia/docker_base_images/blob/master/ruby/CHANGELOG.md).

### Testing the images locally

- Make your changes, then run `docker build ./ruby --build-arg RUBY_VERSION=2.3 -t base-image-test` to build your image
- Temporarily replace the base image of the app you'd like to test against by editing its Dockerfile to say `FROM base-image-test:latest`

### Updating the images

- Make your changes
- Bump the version in `VERSION` and record the change in `CHANGELOG.md`
- Jenkins will build and push on merge to master.

## Local DNS

### How it works

This image contains a simple dns server designed to be used in the development environment only. From within any container that uses this dns server, all references to `*.local.sbndev.net` resolve to the ip address of the host machine (and all other dns forwarded back through regular dns servers). Note that `*.local.sbndev.net` has a _real_ dns entry too, that resolves to localhost, and this dns server shadows that dns entry.

So from within a container, those hostnames resolve to the host machine, and from the host machine (which does not use this dns server), those hostnames resolve to localhost, which is also the host machine.

This allows us to set up standard local hostnames so that containers in different apps can reference each other. Typically we expose the running app container on a particular port on the host machine. For example, hermano is exposed on port 5000. From within another app, e.g. sbn, the hermano app can then be referenced at `hermano.local.sbndev.net:5000`. From within the container, `hermano.local.sbndev.net:5000` resolves to the ip of the host machine at port 5000, which is exactly where the running hermano service is exposed.

### How to use it

The dns server is not included by default. To use it:

* Add the localdns container as a service in the development env's docker-compose, e.g.:

      services:
        dns:
          image: voxmedia/local-dns:A.B.C

* Set up the necessary containers to depend upon this service, and include `use_dns_server` in the entrypoint dispatch (this updates the container's resolve.conf to use this local dns server instead of standard dns), e.g.:

      services:
        app:
          depends_on:
            - dns
          entrypoint:
            - /opt/entrypoint/dispatcher.sh
            - use_dns_server
            - --

### Versioning

The images are tagged `voxmedia/local-dns:A.B.C`, where `A.B.C` is the image version. The image version uses [semantic versioning](https://semver.org).

### Updating the images

- Make your changes
- Bump the version in `VERSION`
- Jenkins will build and push on merge to master.

## Docker Test Kitchen Images

To update it:

- Build it locally with a `docker build .` and note the resulting ID.
- Run `docker tag ID voxmedia/docker_base_images:docker_test_kitchen-VERSION`
- `docker push voxmedia/docker_base_images:docker_test_kitchen-VERSION`
