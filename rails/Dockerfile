FROM voxmedia/docker_base_images:ruby_2.3-0.1

ENV LC_ALL C.UTF-8

RUN apt-get update && apt-get install -y sudo \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

ADD https://s3.amazonaws.com/voxmedia-docker-utils/docker-ssh-exec /usr/local/bin/docker-ssh-exec
RUN chmod +x /usr/local/bin/docker-ssh-exec

ADD entrypoint_scripts /opt/entrypoint/
RUN chmod -R +x /opt/entrypoint/*

ENV PATH /app/bin:$PATH
